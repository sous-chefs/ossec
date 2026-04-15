# frozen_string_literal: true

provides :ossec_server
unified_mode true

use '_partial/_base'

property :server_role, String, default: 'ossec_server'
property :server_env, [String, nil]

action_class do
  include OssecCookbook::Helpers

  def managed_agent_nodes
    search_string = +'ossec:[* TO *]'
    search_string << " AND chef_environment:#{new_resource.server_env}" if new_resource.server_env
    search_string << " AND (NOT role:#{new_resource.server_role}) AND (NOT fqdn:#{node['fqdn']})"
    search_nodes(search_string)
  end

  def agent_identifier(node_data)
    "#{node_data['fqdn'][0..31]} #{node_data['ipaddress']}"
  end

  def missing_agent_nodes
    client_keys = ::File.exist?(client_keys_path(new_resource.install_dir)) ? ::File.read(client_keys_path(new_resource.install_dir)) : ''
    managed_agent_nodes.reject do |node_data|
      client_keys.include?(agent_identifier(node_data))
    end
  end

  def ssh_hosts
    managed_agent_nodes.filter_map do |node_data|
      node_data['ipaddress'] if node_data['keys']
    end.sort
  end
end

action :create do
  ossec_key = load_ossec_data_bag(new_resource.ssh_data_bag_item, new_resource.data_bag_name, new_resource.encrypted_data_bag)
  bulk_file = "#{new_resource.install_dir}/chef-agent-bulk.txt"

  ossec_install 'server' do
    manage_repository new_resource.manage_repository
  end

  file bulk_file do
    owner 'root'
    group 'ossec'
    mode '0640'
    content missing_agent_nodes.sort_by { |node_data| node_data['fqdn'] }.map { |node_data| "#{node_data['ipaddress']},#{node_data['fqdn'][0..31]}" }.join("\n")
  end

  execute 'ossec-manage-agents' do
    command "#{new_resource.install_dir}/bin/manage_agents -f /chef-agent-bulk.txt"
    only_if { ::File.exist?(bulk_file) && !::File.empty?(bulk_file) }
  end

  directory "#{new_resource.install_dir}/.ssh" do
    owner 'root'
    group 'ossec'
    mode '0750'
  end

  file "#{new_resource.install_dir}/.ssh/id_rsa" do
    owner 'root'
    group 'ossec'
    mode '0600'
    content "#{ossec_key['privkey']}\n"
  end

  template '/usr/local/bin/dist-ossec-keys.sh' do
    cookbook 'ossec'
    source 'dist-ossec-keys.sh.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      install_dir: new_resource.install_dir,
      ssh_hosts: ssh_hosts
    )
  end

  ossec_config 'server' do
    install_dir new_resource.install_dir
    ossec_conf new_resource.ossec_conf
    agent_conf new_resource.agent_conf
  end

  cron 'distribute-ossec-keys' do
    minute '0'
    command '/usr/local/bin/dist-ossec-keys.sh'
    only_if { ::File.exist?(client_keys_path(new_resource.install_dir)) }
  end
end

action :delete do
  bulk_file = "#{new_resource.install_dir}/chef-agent-bulk.txt"

  cron 'distribute-ossec-keys' do
    action :delete
  end

  ruby_block 'remove-managed-agent-keys' do
    block do
      next unless ::File.exist?(client_keys_path(new_resource.install_dir))

      lines = ::File.readlines(client_keys_path(new_resource.install_dir), chomp: true)
      keepers = lines.reject do |line|
        managed_agent_nodes.any? do |node_data|
          line.include?(agent_identifier(node_data))
        end
      end
      ::File.write(client_keys_path(new_resource.install_dir), keepers.join("\n"))
    end
  end

  file bulk_file do
    action :delete
  end

  file '/usr/local/bin/dist-ossec-keys.sh' do
    action :delete
  end

  file "#{new_resource.install_dir}/.ssh/id_rsa" do
    action :delete
  end

  directory "#{new_resource.install_dir}/.ssh" do
    recursive true
    action :delete
  end

  ossec_config 'server' do
    install_dir new_resource.install_dir
    action :delete
  end

  ossec_install 'server' do
    manage_repository new_resource.manage_repository
    action :delete
  end
end
