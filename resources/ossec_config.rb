# frozen_string_literal: true

provides :ossec_config
unified_mode true

use '_partial/_base'

property :install_type, String, equal_to: %w(local server agent), name_property: true
property :agent_server_ip, [String, nil]

action_class do
  include OssecCookbook::Helpers

  def default_all_conf
    {
      'syscheck' => {
        'frequency' => 21_600,
      },
      'rootcheck' => {
        'disabled' => false,
        'rootkit_files' => "#{new_resource.install_dir}/etc/shared/rootkit_files.txt",
        'rootkit_trojans' => "#{new_resource.install_dir}/etc/shared/rootkit_trojans.txt",
      },
    }
  end

  def default_type_conf
    case new_resource.install_type
    when 'local', 'server'
      {
        'global' => {
          'email_notification' => false,
          'email_from' => "ossecm@#{node['fqdn']}",
          'email_to' => 'ossec@example.com',
          'smtp_server' => '127.0.0.1',
        },
        'alerts' => {
          'email_alert_level' => 7,
          'log_alert_level' => 1,
        },
      }.tap do |conf|
        conf['remote'] = { 'connection' => 'secure' } if new_resource.install_type == 'server'
      end
    when 'agent'
      {
        'client' => {
          'server-ip' => new_resource.agent_server_ip,
        },
      }
    end
  end

  def merged_ossec_conf
    base = deep_merge_hash(default_type_conf, default_all_conf)
    deep_merge_hash(new_resource.ossec_conf, base)
  end

  def service_should_run?
    return true if new_resource.install_type == 'local'

    client_keys = client_keys_path(new_resource.install_dir)
    return false unless ::File.exist?(client_keys)
    return false if ::File.empty?(client_keys)
    return false if new_resource.install_type == 'agent' && new_resource.agent_server_ip.nil?

    true
  end
end

action :create do
  chef_gem 'gyoku' do
    compile_time false
  end

  file ossec_conf_path(new_resource.install_dir) do
    owner 'root'
    group 'ossec'
    mode '0440'
    manage_symlink_source true
    content lazy { ossec_to_xml('ossec_config' => merged_ossec_conf) }
    notifies :restart, "systemd_unit[restart #{ossec_main_service_name}]", :delayed
  end

  file agent_conf_path(new_resource.install_dir) do
    owner 'root'
    group 'ossec'
    mode '0440'
    content lazy {
      if new_resource.install_type == 'server'
        ossec_to_xml('agent_config' => new_resource.agent_conf)
      else
        ''
      end
    }
    notifies :restart, "systemd_unit[restart #{ossec_main_service_name}]", :delayed
  end

  systemd_unit "restart #{ossec_main_service_name}" do
    unit_name "#{ossec_main_service_name}.service"
    action :nothing
  end

  systemd_unit "enable #{ossec_main_service_name}" do
    unit_name "#{ossec_main_service_name}.service"
    action :enable
  end

  systemd_unit "start #{ossec_main_service_name}" do
    unit_name "#{ossec_main_service_name}.service"
    action :start
    only_if { service_should_run? }
  end
end

action :delete do
  systemd_unit "#{ossec_main_service_name}.service" do
    action %i(stop disable)
    only_if { ::File.exist?(::File.join('/usr/lib/systemd/system', "#{ossec_main_service_name}.service")) || ::File.exist?(::File.join('/lib/systemd/system', "#{ossec_main_service_name}.service")) }
  end

  file ossec_conf_path(new_resource.install_dir) do
    action :delete
  end

  file agent_conf_path(new_resource.install_dir) do
    action :delete
  end
end
