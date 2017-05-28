#
# Cookbook Name:: ossec
# Attributes:: authd
#
# Copyright 2015, Opscode, Inc.
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

default['ossec']['authd']['ip_address'] = false
default['ossec']['authd']['port'] = 1515

default['ossec']['authd']['ca'] = nil
default['ossec']['authd']['certificate'] = "#{node['ossec']['dir']}/etc/sslmanager.cert"
default['ossec']['authd']['key'] = "#{node['ossec']['dir']}/etc/sslmanager.key"

default['ossec']['agent_auth']['name'] = node['fqdn']
default['ossec']['agent_auth']['host'] = node['ossec']['agent_server_ip']
default['ossec']['agent_auth']['port'] = node['ossec']['authd']['port']

default['ossec']['agent_auth']['ca'] = nil
default['ossec']['agent_auth']['certificate'] = nil
default['ossec']['agent_auth']['key'] = nil
