require 'spec_helper'
require 'json'

describe 'ossec::client' do
  let(:data_bags_path) { File.expand_path('../../../../test/fixtures/data_bags', __FILE__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |_node, server|
      server.create_data_bag('ossec', 'ssh' => data_bag_ossec_ssh)
    end.converge('ossec::client')
  end

  it 'includes ossec::client recipe' do
    expect(chef_run).to include_recipe('ossec')
  end

  it 'creates ossecd user' do
    expect(chef_run).to create_user('ossecd').with(
      comment: 'OSSEC Distributor',
      shell: '/bin/bash',
      system: true,
      gid: 'ossec',
      home: chef_run.node['ossec']['user']['dir']
    )
  end

  it 'creates ossecd user .ssh directory' do
    expect(chef_run).to create_directory("#{chef_run.node['ossec']['user']['dir']}/.ssh").with(
      owner: 'ossecd',
      group: 'ossec',
      mode: 0750
    )
  end

  it 'creates ossec user authorized_keys template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['user']['dir']}/.ssh/authorized_keys").with(
      source: 'ssh_key.erb',
      owner: 'ossecd',
      group: 'ossec',
      mode: 0600
    )
  end

  it 'creates ossec user /etc/client.keys file' do
    expect(chef_run).to create_file("#{chef_run.node['ossec']['user']['dir']}/etc/client.keys").with(
      owner: 'ossecd',
      group: 'ossec',
      mode: 0660
    )
  end
end
