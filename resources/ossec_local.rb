# frozen_string_literal: true

provides :ossec_local
unified_mode true

use '_partial/_base'

action :create do
  ossec_install 'server' do
    manage_repository new_resource.manage_repository
  end

  ossec_config 'local' do
    install_dir new_resource.install_dir
    ossec_conf new_resource.ossec_conf
    agent_conf new_resource.agent_conf
  end
end

action :delete do
  ossec_config 'local' do
    install_dir new_resource.install_dir
    action :delete
  end

  ossec_install 'server' do
    manage_repository new_resource.manage_repository
    action :delete
  end
end
