#
# Cookbook:: ossec
# Recipe:: server
#
# Copyright:: 2010-2017, Chef Software, Inc.
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

include_recipe 'ossec::install_server'

ssh_hosts = []

search_string = 'ossec:[* TO *]'
search_string << " AND chef_environment:#{node['ossec']['server_env']}" if node['ossec']['server_env']
search_string << " AND NOT role:#{node['ossec']['server_role']} AND NOT fqdn:#{node['fqdn']}"

filter_keys = { 'fqdn' => ['fqdn'], 'ipaddress' => ['ipaddress'] }

search(:node, search_string, filter_result: filter_keys).each do |n|
  ssh_hosts << n['ipaddress'] if n['keys']

  execute "#{node['ossec']['agent_manager']} -a --ip #{n['ipaddress']} -n #{n['fqdn'][0..31]}" do
    not_if "grep '#{n['fqdn'][0..31]} #{n['ipaddress']}' #{node['ossec']['dir']}/etc/client.keys"
  end
end

template '/usr/local/bin/dist-ossec-keys.sh' do
  source 'dist-ossec-keys.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(ssh_hosts: ssh_hosts.sort)
  not_if { ssh_hosts.empty? }
end

dbag_name = node['ossec']['data_bag']['name']
dbag_item = node['ossec']['data_bag']['ssh']
ossec_key = data_bag_item(dbag_name, dbag_item)

directory "#{node['ossec']['dir']}/.ssh" do
  owner 'root'
  group 'ossec'
  mode '0750'
end

template "#{node['ossec']['dir']}/.ssh/id_rsa" do
  source 'ssh_key.erb'
  owner 'root'
  group 'ossec'
  mode '0600'
  variables(key: ossec_key['privkey'])
end

include_recipe 'ossec::common'

cron 'distribute-ossec-keys' do
  minute '0'
  command '/usr/local/bin/dist-ossec-keys.sh'
  only_if { ::File.exist?("#{node['ossec']['dir']}/etc/client.keys") }
end
