# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe 'ossec_server' do
  step_into :ossec_server
  platform 'ubuntu', '24.04'

  let(:data_bags_path) { File.expand_path('../../../test/fixtures/data_bags', __dir__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    www_node = stub_node(platform: 'ubuntu', version: '24.04') do |node|
      node.normal['ipaddress'] = '192.0.2.20'
      node.normal['fqdn'] = 'chefspec-client.local'
      node.normal['keys'] = { 'ssh' => ['ssh-rsa AAAA'] }
      node.normal['ossec'] = { 'enabled' => true }
    end

    runner = ChefSpec::ServerRunner.new(step_into: %w(ossec_server ossec_install ossec_config ossec_repository), platform: 'ubuntu', version: '24.04') do |_node, server|
      server.create_node(www_node, run_list: ['ossec_client'])
      server.create_data_bag('ossec', 'ssh' => data_bag_ossec_ssh)
    end

    runner.converge_block do
      ossec_server 'default'
    end
  end

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  it 'installs the server package' do
    expect(chef_run).to install_package('ossec-hids-server')
  end

  it 'creates the key distribution script' do
    expect(chef_run).to create_template('/usr/local/bin/dist-ossec-keys.sh')
  end
end
