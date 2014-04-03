#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "create raid device" do
  command "mdadm --create --verbose #{node[:raid][:verbose]} --level=#{node[:raid][:level]} --raid-devices=#{node[:raid][:devices].length} #{node[:raid][:devices].join(" ")}"
  action :run
  not_if { File.exist?(node[:raid][:verbose]) }
end

execute "make file system" do
  command "mkfs.#{node[:raid][:fs]}"
  action :run
  not_if "mkfs -V #{node[:raid][:verbose]} | grep -q #{node[:raid][:fs]}"
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
end

