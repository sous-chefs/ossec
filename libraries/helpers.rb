# frozen_string_literal: true

require 'chef/mixin/deep_merge'
require 'chef/search/query'

module OssecCookbook
  module Helpers
    def ossec_apt_repo_dist
      if node['os_release']
        node['os_release']['version_codename']
      elsif node['lsb']
        node['lsb']['codename']
      else
        raise 'unable to determine the release codename for the Atomicorp apt repository'
      end
    end

    def ossec_apt_repo_trusted?
      platform?('debian') && node['platform_version'].to_i == 13
    end

    def ossec_yum_repo_baseurl
      if platform?('amazon')
        "https://updates.atomicorp.com/channels/atomic/amazon/#{node['platform_version'].to_i}/$basearch"
      else
        'https://updates.atomicorp.com/channels/atomic/centos/$releasever/$basearch'
      end
    end

    def ossec_deb_arch
      case node['kernel']['machine']
      when 'aarch64', 'arm64'
        'arm64'
      else
        'amd64'
      end
    end

    def ossec_package_name(package_type)
      case package_type
      when 'agent'
        'ossec-hids-agent'
      when 'server'
        'ossec-hids-server'
      else
        raise "unsupported OSSEC package type: #{package_type}"
      end
    end

    def ossec_main_service_name
      platform_family?('debian') ? 'ossec' : 'ossec-hids'
    end

    def ossec_authd_service_name
      platform_family?('debian') ? 'ossec-authd' : 'ossec-hids-authd'
    end

    def ossec_to_xml(hash)
      require 'gyoku'
      Gyoku.xml(object_to_ossec(hash))
    end

    def deep_merge_hash(override, base)
      Chef::Mixin::DeepMerge.deep_merge(override, base)
    end

    def client_keys_path(install_dir)
      ::File.join(install_dir, 'etc', 'client.keys')
    end

    def agent_conf_path(install_dir)
      ::File.join(install_dir, 'etc', 'shared', 'agent.conf')
    end

    def ossec_conf_path(install_dir)
      ::File.join(install_dir, 'etc', 'ossec.conf')
    end

    def load_ossec_data_bag(item_name, bag_name, _encrypted)
      data_bag_item(bag_name, item_name)
    end

    def search_nodes(search_string, filter_result: nil)
      Chef::Search::Query.new.search(:node, search_string, filter_result: filter_result).first
    end

    private

    def object_to_ossec(object)
      case object
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[key == 'content!' ? :content! : key] = object_to_ossec(value)
        end
      when Array
        object.map { |entry| object_to_ossec(entry) }
      when TrueClass
        'yes'
      when FalseClass
        'no'
      when NilClass
        ''
      else
        object
      end
    end
  end
end
