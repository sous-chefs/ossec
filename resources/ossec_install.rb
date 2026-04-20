# frozen_string_literal: true

provides :ossec_install
unified_mode true

property :package_type, String, equal_to: %w(agent server), name_property: true
property :manage_repository, [true, false], default: true

action_class do
  include OssecCookbook::Helpers
end

action :create do
  ossec_repository 'default' if new_resource.manage_repository

  package_name = ossec_package_name(new_resource.package_type)

  package package_name do
    action :install
  end

  systemd_unit "#{ossec_main_service_name}.service" do
    action %i(stop disable)
    only_if { ::File.exist?(::File.join('/usr/lib/systemd/system', "#{ossec_main_service_name}.service")) || ::File.exist?(::File.join('/lib/systemd/system', "#{ossec_main_service_name}.service")) }
  end
end

action :delete do
  systemd_unit "#{ossec_main_service_name}.service" do
    action %i(stop disable)
    only_if { ::File.exist?(::File.join('/usr/lib/systemd/system', "#{ossec_main_service_name}.service")) || ::File.exist?(::File.join('/lib/systemd/system', "#{ossec_main_service_name}.service")) }
  end

  package ossec_package_name(new_resource.package_type) do
    action :remove
  end

  ossec_repository 'default' do
    action :delete
    only_if { new_resource.manage_repository }
  end
end
