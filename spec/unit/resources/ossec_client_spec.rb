# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe 'ossec_client' do
  step_into :ossec_client
  platform 'ubuntu', '24.04'

  let(:data_bags_path) { File.expand_path('../../../test/fixtures/data_bags', __dir__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    runner = ChefSpec::ServerRunner.new(step_into: %w(ossec_client ossec_install ossec_config ossec_repository), platform: 'ubuntu', version: '24.04') do |_node, server|
      server.create_data_bag('ossec', 'ssh' => data_bag_ossec_ssh)
    end

    runner.converge_block do
      ossec_client 'default' do
        agent_server_ip '192.0.2.10'
        client_keys_content '001 test-agent 192.0.2.10 deadbeef'
      end
    end
  end

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(true)
    allow(File).to receive(:empty?).and_call_original
    allow(File).to receive(:empty?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  it 'installs the agent package' do
    expect(chef_run).to install_package('ossec-hids-agent')
  end

  it 'creates the authorized keys file' do
    expect(chef_run).to create_file('/var/ossec/.ssh/authorized_keys')
  end
end
