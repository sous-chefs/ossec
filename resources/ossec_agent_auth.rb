# frozen_string_literal: true

provides :ossec_agent_auth
unified_mode true

use '_partial/_base'

property :agent_name, String, default: lazy { node['fqdn'] }
property :server_role, String, default: 'ossec_server'
property :server_env, [String, nil]
property :agent_server_ip, [String, nil]
property :port, Integer, default: 1515
property :ca, [String, nil]
property :certificate, [String, nil]
property :key, [String, nil]

action_class do
  include OssecCookbook::Helpers

  def resolved_agent_server_ip
    return new_resource.agent_server_ip if new_resource.agent_server_ip

    search_string = "role:#{new_resource.server_role}"
    search_string << " AND chef_environment:#{new_resource.server_env}" if new_resource.server_env

    if node.run_list.roles.include?(new_resource.server_role)
      node['ipaddress']
    else
      search_nodes(search_string).first&.dig('ipaddress')
    end
  end

  def agent_auth_args
    args = [
      "-m #{resolved_agent_server_ip}",
      "-p #{new_resource.port}",
      "-A #{new_resource.agent_name}",
    ]
    args << "-v #{new_resource.ca}" if new_resource.ca && ::File.exist?(new_resource.ca)
    args << "-x #{new_resource.certificate}" if new_resource.certificate && ::File.exist?(new_resource.certificate)
    args << "-k #{new_resource.key}" if new_resource.key && ::File.exist?(new_resource.key)
    args.join(' ')
  end
end

action :create do
  ossec_install 'agent' do
    manage_repository new_resource.manage_repository
  end

  execute 'ossec-agent-auth' do
    command "#{new_resource.install_dir}/bin/agent-auth #{agent_auth_args}"
    timeout 30
    ignore_failure true
    only_if { resolved_agent_server_ip && !::File.size?(client_keys_path(new_resource.install_dir)) }
  end

  ossec_config 'agent' do
    install_dir new_resource.install_dir
    ossec_conf new_resource.ossec_conf
    agent_server_ip resolved_agent_server_ip
  end
end

action :delete do
  ossec_config 'agent' do
    install_dir new_resource.install_dir
    action :delete
  end

  file client_keys_path(new_resource.install_dir) do
    action :delete
  end

  ossec_install 'agent' do
    manage_repository new_resource.manage_repository
    action :delete
  end
end
