# frozen_string_literal: true

provides :ossec_client
unified_mode true

use '_partial/_base'

property :server_role, String, default: 'ossec_server'
property :server_env, [String, nil]
property :agent_server_ip, [String, nil]
property :client_keys_content, [String, nil]

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
end

action :create do
  ossec_key = load_ossec_data_bag(new_resource.ssh_data_bag_item, new_resource.data_bag_name, new_resource.encrypted_data_bag)

  ossec_install 'agent' do
    manage_repository new_resource.manage_repository
  end

  directory "#{new_resource.install_dir}/.ssh" do
    owner 'ossec'
    group 'ossec'
    mode '0750'
  end

  file "#{new_resource.install_dir}/.ssh/authorized_keys" do
    owner 'ossec'
    group 'ossec'
    mode '0600'
    content "#{ossec_key['pubkey']}\n"
  end

  file client_keys_path(new_resource.install_dir) do
    owner 'ossec'
    group 'ossec'
    mode '0660'
    content new_resource.client_keys_content.to_s
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

  file "#{new_resource.install_dir}/.ssh/authorized_keys" do
    action :delete
  end

  directory "#{new_resource.install_dir}/.ssh" do
    recursive true
    action :delete
  end

  ossec_install 'agent' do
    manage_repository new_resource.manage_repository
    action :delete
  end
end
