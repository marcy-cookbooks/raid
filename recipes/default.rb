#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "expect" do
  action :install
end

node[:raid][:devices].each do |dev|
  if node[:filesystem].key?(dev) && node[:filesystem][dev].key?('mount') then
    mount node[:filesystem][dev][:mount] do
      device dev
      action :umount
      only_if {node[:filesystem][dev][:mount] != node[:raid][:mount_point]}
    end
  end
end

execute "create raid device" do
  command <<-EOH
  expect -c "
  Continue creating array
  spawn mdadm --create --verbose #{node[:raid][:verbose]} --level=#{node[:raid][:level]} --raid-devices=#{node[:raid][:devices].length} #{node[:raid][:devices].join(" ")}
  expect Continue\ creating\ array?; send \"yes\r\"
  "
  EOH
  action :run
  not_if { File.exist?(node[:raid][:verbose]) }
end

execute "make file system" do
  command "mkfs.#{node[:raid][:fs]} #{node[:raid][:verbose]}"
  action :run
  not_if {
    node[:filesystem].key?(node[:raid][:verbose]) &&
    node[:filesystem][node[:raid][:verbose]][:fs_type] != node[:raid][:fs]
  }
end

directory node[:raid][:mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

mount node[:raid][:mount_point] do
  device node[:raid][:verbose]
  fstype node[:raid][:fs]
  action :mount
end

