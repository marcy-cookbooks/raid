#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "xfsprogs" do
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


mdadm default['raid']['verbose'] do
  devices node['raid']['devices']
  level node['raid']['level']
  action [ :create, :assemble ]
end

directory node[:raid][:mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

mount node[:raid][:mount_point] do
  device node[:raid][:verbose]
  fstype node[:raid][:fs]
  action [:mount]
end

