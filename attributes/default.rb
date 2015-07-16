#
# Cookbook Name:: ossec
# Attributes:: default
#
# Copyright 2010-2015, Chef Software, Inc.
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

# general settings
default['ossec']['server_role'] = 'ossec_server'
default['ossec']['server_env']  = nil
default['ossec']['logs']        = []
default['ossec']['syscheck_freq'] = 79_200
default['ossec']['disable_config_generation'] = false

# data bag configuration
default['ossec']['data_bag']['encrypted']  = false
default['ossec']['data_bag']['name']       = 'ossec'
default['ossec']['data_bag']['ssh']        = 'ssh'

# used to populate config files and preload values for install
default['ossec']['user']['dir'] = '/var/ossec'
default['ossec']['user']['syscheck'] = true
default['ossec']['user']['rootcheck'] = true
default['ossec']['user']['agent_server_ip'] = nil
default['ossec']['user']['enable_email'] = true
default['ossec']['user']['email'] = 'ossec@example.com'
default['ossec']['user']['smtp'] = '127.0.0.1'
default['ossec']['user']['white_list'] = []

# ossec-batch-manager.pl location varies
default['ossec']['agent_manager'] = value_for_platform_family(
  %w( rhel fedora suse ) => '/usr/share/ossec/contrib/ossec-batch-manager.pl',
  'default' => "#{node['ossec']['user']['dir']}/contrib/ossec-batch-manager.pl"
)
