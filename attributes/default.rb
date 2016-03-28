#
# Cookbook Name:: ossec
# Attributes:: default
#
# Copyright 2010-2016, Chef Software, Inc.
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
default['ossec']['dir']             = '/var/ossec'
default['ossec']['server_role']     = 'ossec_server'
default['ossec']['server_env']      = nil
default['ossec']['agent_server_ip'] = nil

# data bag configuration
default['ossec']['data_bag']['encrypted']  = false
default['ossec']['data_bag']['name']       = 'ossec'
default['ossec']['data_bag']['ssh']        = 'ssh'

# ossec-batch-manager.pl location varies
default['ossec']['agent_manager'] = value_for_platform_family(
  %w( rhel fedora suse ) => '/usr/share/ossec/contrib/ossec-batch-manager.pl',
  'default' => "#{node['ossec']['dir']}/contrib/ossec-batch-manager.pl"
)

# The following attributes are mapped to XML for ossec.conf using
# Gyoku. See the README for details on how this works.

default['ossec']['conf']['all']['syscheck']['frequency'] = 21_600
default['ossec']['conf']['all']['rootcheck']['disabled'] = false
default['ossec']['conf']['all']['rootcheck']['rootkit_files'] = "#{node['ossec']['dir']}/etc/shared/rootkit_files.txt"
default['ossec']['conf']['all']['rootcheck']['rootkit_trojans'] = "#{node['ossec']['dir']}/etc/shared/rootkit_trojans.txt"

%w( local server ).each do |type|
  default['ossec']['conf'][type]['global']['email_notification'] = false
  default['ossec']['conf'][type]['global']['email_from'] = "ossecm@#{node['fqdn']}"
  default['ossec']['conf'][type]['global']['email_to'] = 'ossec@example.com'
  default['ossec']['conf'][type]['global']['smtp_server'] = '127.0.0.1'

  default['ossec']['conf'][type]['alerts']['email_alert_level'] = 7
  default['ossec']['conf'][type]['alerts']['log_alert_level'] = 1
  default['ossec']['conf'][type]['alerts']['use_geoip'] = false unless platform_family?('debian')
end

default['ossec']['conf']['server']['remote']['connection'] = 'secure'
default['ossec']['conf']['agent']['client']['server-ip'] = node['ossec']['agent_server_ip']

# agent.conf is also populated with Gyoku but in a slightly different
# way. We leave this blank by default because Chef is better at
# distributing agent configuration than OSSEC is.
default['ossec']['agent_conf'] = []
