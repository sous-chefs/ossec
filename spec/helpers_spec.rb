# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe OssecCookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include OssecCookbook::Helpers

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def platform?(*platforms)
        platforms.include?(node['platform'])
      end

      def platform_family?(*families)
        families.include?(node['platform_family'])
      end
    end
  end

  let(:ubuntu_node) do
    Fauxhai.mock(platform: 'ubuntu', version: '24.04').data
  end

  subject(:helper) { helper_class.new(ubuntu_node) }

  it 'uses the suite codename for the apt distribution on Ubuntu 24.04' do
    expect(helper.ossec_apt_repo_dist).to eq('noble')
  end

  it 'returns the correct server package name' do
    expect(helper.ossec_package_name('server')).to eq('ossec-hids-server')
  end
end
