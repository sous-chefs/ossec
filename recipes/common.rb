#
# Cookbook Name:: ossec
# Recipe:: common
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

ruby_block 'ossec install_type' do
  block do
    if node.recipes.include?('ossec::default')
      type = 'local'
    else
      type = nil

      File.open('/etc/ossec-init.conf') do |file|
        file.each_line do |line|
          if line =~ /^TYPE="([^"]+)"/
            type = Regexp.last_match(1)
            break
          end
        end
      end
    end

    node.set['ossec']['user']['install_type'] = type
  end
end

template "#{node['ossec']['user']['dir']}/etc/ossec.conf" do
  source 'ossec.conf.erb'
  owner 'root'
  group 'ossec'
  mode 0440
  manage_symlink_source true
  variables lazy { { ossec: node['ossec']['user'] } }
  not_if { node['ossec']['disable_config_generation'] }
  notifies :restart, 'service[ossec]'
end

# Both the RPM and DEB packages enable and start the service
# immediately after installation, which isn't helpful. An empty
# client.keys file will cause a server not to listen and an agent to
# abort immediately. Explicitly stopping the service here after
# installation allows Chef to start it when client.keys has content.
service 'stop ossec' do
  service_name 'ossec-hids' unless platform_family?('debian')
  action :nothing

  %w( disable stop ).each do |action|
    subscribes action, 'package[ossec]', :immediately
  end
end

service 'ossec' do
  service_name 'ossec-hids' unless platform_family?('debian')
  supports status: true, restart: true
  action [:enable, :start]

  not_if do
    (node['ossec']['user']['install_type'] != 'local' && !File.size?("#{node['ossec']['user']['dir']}/etc/client.keys")) ||
      (node['ossec']['user']['install_type'] == 'agent' && node['ossec']['user']['agent_server_ip'].nil?)
  end
end
