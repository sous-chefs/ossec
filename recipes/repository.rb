#
# Cookbook:: ossec
# Recipe:: repository
#
# Copyright:: 2015-2017, Chef Software, Inc.
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

case node['platform_family']
when 'fedora', 'rhel'
  include_recipe 'yum-atomic'
when 'debian'
  package 'lsb-release'

  ohai 'reload lsb' do
    plugin 'lsb'
    action :nothing
    subscribes :reload, 'package[lsb-release]', :immediately
  end
  dist = node['lsb']['codename'] 
  if platform?('ubuntu') && node['platform_version'].to_f >= 20.04
        dist = node['lsb']['codename']  + '/' + node['packages']['apt']['arch'] + '/' 
    elsif platform?('debian') && node['platform_version'].to_i >= 11
        dist = node['lsb']['codename']  + '/' + node['packages']['apt']['arch'] + '/' 
  end
  apt_repository 'ossec' do
    uri 'https://updates.atomicorp.com/channels/atomic/' + node['platform']
    key 'https://updates.atomicorp.com/installers/RPM-GPG-KEY.atomicorp.txt'
    distribution #{dist}
    components ['main']
  end
end
