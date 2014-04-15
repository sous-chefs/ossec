#
# Cookbook Name:: ossec
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform?('ubuntu')
  include_recipe "apt"
end
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "ossec::server"

user_databag = node['ossec']['users_databag'].to_sym
group = node['ossec']['users_databag_group']
begin
  sysadmins = search(user_databag, "groups:#{group} NOT action:remove")
rescue Net::HTTPServerException
  Chef::Log.fatal("Could not find appropriate items in the \"#{node['ossec']['users_databag']}\" databag.  Check to make sure the databag exists and if you have set the \"users_databag_group\" that users in that group exist")
  raise 'Could not find appropriate items in the "users" databag.  Check to make sure there is a users databag and if you have set the "users_databag_group" that users in that group exist'
end

group 'ossec' do
  members node['apache']['group']
end

apache_dir = node['apache']['dir']
apache_doc_root = "#{apache_dir}/htdocs"

directory apache_doc_root do
    action :create
end

ossec_wui_dir = "ossec-wui-#{node['ossec']['wui']['version']}"

remote_file "#{Chef::Config[:file_cache_path]}/#{ossec_wui_dir}.tar.gz" do
  source node['ossec']['wui']['url']
  checksum node['ossec']['wui']['checksum']
end

bash 'unpackage-ossec-wui' do
  code <<-EOH
  tar zxvf #{Chef::Config[:file_cache_path]}/#{ossec_wui_dir}.tar.gz
  mv #{ossec_wui_dir} ossec-wui
  EOH
  cwd apache_doc_root
  creates "#{apache_doc_root}/ossec-wui"
end

directory "#{apache_dir}/ossec" do
    action :create
end

template "#{apache_doc_root}/ossec-wui/.htaccess" do
  source 'htaccess.erb'
  owner node['apache']['user']
  group node['apache']['group']
  variables({ :htpasswd => "#{apache_dir}/ossec/.htpasswd" })
  notifies :restart, "service[apache2]"
end

template "#{apache_dir}/ossec/.htpasswd" do
  source 'htpasswd.erb'
  owner node['apache']['user']
  group node['apache']['group']
  variables({ :sysadmins => sysadmins })
  notifies :restart, "service[apache2]"
end
