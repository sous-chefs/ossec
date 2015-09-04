#
# Cookbook Name:: ossec
# Recipe:: authd
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

include_recipe 'ossec::install_server'
include_recipe 'ossec::common'

authd = node['ossec']['authd']

if node['init_package'] == 'systemd'
  template 'ossec-authd init' do
    path '/lib/systemd/system/ossec-authd.service'
    source 'ossec-authd.service.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables authd
  end

  execute 'systemctl daemon-reload' do
    action :nothing
    subscribes :run, 'template[ossec-authd init]', :immediately
  end
end

service 'ossec-authd' do
  supports restart: true
  action [:enable, :start]
  subscribes :restart, 'template[ossec-authd init]'

  only_if do
    File.exist?(authd['certificate']) && File.exist?(authd['key']) &&
      (authd['ca'].nil? || File.exist?(authd['ca']))
  end
end
