# frozen_string_literal: true

provides :ossec_repository
unified_mode true

action_class do
  include OssecCookbook::Helpers
end

action :create do
  case node['platform_family']
  when 'debian'
    apt_repository 'ossec' do
      uri "https://updates.atomicorp.com/channels/atomic/#{node['platform']}"
      key 'https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt'
      arch ossec_deb_arch
      distribution ossec_apt_repo_dist
      components %w(main)
      trusted ossec_apt_repo_trusted?
      action :add
    end
  when 'rhel', 'fedora', 'amazon'
    yum_repository 'ossec' do
      description 'Atomicorp OSSEC packages'
      baseurl ossec_yum_repo_baseurl
      gpgkey 'https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt'
      gpgcheck true
      enabled true
      action :create
    end
  else
    raise "ossec_repository does not support #{node['platform_family']}"
  end
end

action :delete do
  case node['platform_family']
  when 'debian'
    apt_repository 'ossec' do
      uri "https://updates.atomicorp.com/channels/atomic/#{node['platform']}"
      action :remove
    end
  when 'rhel', 'fedora', 'amazon'
    yum_repository 'ossec' do
      action :remove
    end
  end
end
