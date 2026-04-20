# frozen_string_literal: true

provides :ossec_authd
unified_mode true

use '_partial/_base'

property :ip_address, [true, false], default: false
property :port, Integer, default: 1515
property :ca, [String, nil]
property :certificate, String, default: lazy { "#{install_dir}/etc/sslmanager.cert" }
property :key, String, default: lazy { "#{install_dir}/etc/sslmanager.key" }

action_class do
  include OssecCookbook::Helpers

  def authd_unit_content
    command = [
      "#{new_resource.install_dir}/bin/ossec-authd",
      "-p #{new_resource.port}",
      ('-i' if new_resource.ip_address),
      "-x #{new_resource.certificate}",
      "-k #{new_resource.key}",
      ("-v #{new_resource.ca}" if new_resource.ca),
    ].compact.join(' ')

    {
      Unit: {
        Description: 'OSSEC authd',
        After: 'network.target',
      },
      Service: {
        Environment: [
          "DIRECTORY=#{new_resource.install_dir}",
        ],
        ExecStart: "/usr/bin/env #{command}",
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
    }
  end

  def authd_ready?
    ::File.exist?(new_resource.certificate) &&
      ::File.exist?(new_resource.key) &&
      (new_resource.ca.nil? || ::File.exist?(new_resource.ca))
  end
end

action :create do
  ossec_install 'server' do
    manage_repository new_resource.manage_repository
  end

  ossec_config 'server' do
    install_dir new_resource.install_dir
    ossec_conf new_resource.ossec_conf
    agent_conf new_resource.agent_conf
  end

  systemd_unit "enable #{ossec_authd_service_name}" do
    unit_name "#{ossec_authd_service_name}.service"
    content authd_unit_content
    action %i(create enable)
  end

  systemd_unit "start #{ossec_authd_service_name}" do
    unit_name "#{ossec_authd_service_name}.service"
    action :start
    only_if { authd_ready? }
  end
end

action :delete do
  systemd_unit "#{ossec_authd_service_name}.service" do
    action %i(stop disable delete)
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
