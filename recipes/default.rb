#
# Cookbook Name:: raid
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "xfsprogs"
package "mdadm"

node[:raid][:devices].each do |dev|
  if node[:filesystem].key?(dev) && node[:filesystem][dev].key?('mount') then
    mount node[:filesystem][dev][:mount] do
      device dev
      action [:umount, :disable]
      only_if {node[:filesystem][dev][:mount] != node[:raid][:mount_point]}
    end
  end
end

execute "format-device" do
  action :nothing
  command <<-EOH
blockdev --setra 65536 #{node[:raid][:verbose]}
mkfs.#{node[:raid][:fs]} -f #{node[:raid][:verbose]}
echo "DEVICE #{node[:raid][:devices].join(" ")}" > /etc/mdadm.conf
mdadm --detail --scan >> /etc/mdadm.conf
EOH
end

mdadm node['raid']['verbose'] do
  devices node['raid']['devices']
  level node['raid']['level']
  action :create
  notifies :run, 'execute[format-device]', :immediately
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
  options "defaults,noatime,nofail"
  action [:mount, :enable]
end
