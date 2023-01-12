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
  node.default['yum']['atomic']['mirrorlist'] = nil
  node.default['yum']['atomic']['baseurl'] =
    'https://updates.atomicorp.com/channels/atomic/centos/$releasever/$basearch'

  include_recipe 'yum-atomic'
when 'debian'
  apt_repository 'ossec' do
    uri "https://updates.atomicorp.com/channels/atomic/#{node['platform']}"
    key 'https://updates.atomicorp.com/installers/RPM-GPG-KEY.atomicorp.txt'
    arch ossec_deb_arch
    distribution ossec_apt_repo_dist
    trusted true if ossec_apt_new_layout?
    components ossec_apt_new_layout? ? [] : %w(main)
  end
end
