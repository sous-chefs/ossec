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

  let(:debian_13_node) do
    Fauxhai.mock(platform: 'debian', version: '13').data
  end

  let(:debian_12_node) do
    Fauxhai.mock(platform: 'debian', version: '12').data
  end

  let(:amazon_2023_node) do
    Fauxhai.mock(platform: 'amazon', version: '2023').data
  end

  subject(:helper) { helper_class.new(ubuntu_node) }

  it 'uses the suite codename for the apt distribution on Ubuntu 24.04' do
    expect(helper.ossec_apt_repo_dist).to eq('noble')
  end

  it 'returns the correct server package name' do
    expect(helper.ossec_package_name('server')).to eq('ossec-hids-server')
  end

  it 'marks Debian 13 repositories as trusted for apt' do
    expect(helper_class.new(debian_13_node).ossec_apt_repo_trusted?).to be(true)
  end

  it 'does not mark Debian 12 repositories as trusted for apt' do
    expect(helper_class.new(debian_12_node).ossec_apt_repo_trusted?).to be(false)
  end

  it 'does not mark Ubuntu repositories as trusted for apt' do
    expect(helper.ossec_apt_repo_trusted?).to be(false)
  end

  it 'uses the Amazon 2023 repository path on Amazon Linux 2023' do
    expect(helper_class.new(amazon_2023_node).ossec_yum_repo_baseurl).to eq(
      'https://updates.atomicorp.com/channels/atomic/amazon/2023/$basearch'
    )
  end
end
