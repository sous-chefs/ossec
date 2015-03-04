#
# Cookbook Name:: ossec
# Recipe:: server
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

agent_manager = "#{node['ossec']['user']['dir']}/bin/ossec-batch-manager.pl"

ssh_hosts = Array.new

search_string = "ossec:[* TO *]" 
search_string << " AND chef_environment:#{node['ossec']['server_env']}" if node['ossec']['server_env']
search_string << " NOT role:#{node['ossec']['server_role']}"

search(:node, search_string) do |n|

  ssh_hosts << n['ipaddress'] if n['keys']

  execute "#{agent_manager} -a --ip #{n['ipaddress']} -n #{n['fqdn'][0..31]}" do
    not_if "grep '#{n['fqdn'][0..31]} #{n['ipaddress']}' #{node['ossec']['user']['dir']}/etc/client.keys"
  end

end
