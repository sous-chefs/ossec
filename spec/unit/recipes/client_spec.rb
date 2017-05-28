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

  it 'includes ossec::common recipe' do
    expect(chef_run).to include_recipe('ossec::client')
  end

  it 'includes ossec::install_agent recipe' do
    expect(chef_run).to include_recipe('ossec::install_agent')
  end

  it 'creates ossecd user .ssh directory' do
    expect(chef_run).to create_directory("#{chef_run.node['ossec']['dir']}/.ssh").with(
      owner: 'ossec',
      group: 'ossec',
      mode: '0750'
    )
  end

  it 'creates ossec user authorized_keys template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['dir']}/.ssh/authorized_keys").with(
      source: 'ssh_key.erb',
      owner: 'ossec',
      group: 'ossec',
      mode: '0600'
    )
  end

  it 'creates ossec user /etc/client.keys file' do
    expect(chef_run).to create_file("#{chef_run.node['ossec']['dir']}/etc/client.keys").with(
      owner: 'ossec',
      group: 'ossec',
      mode: '0660'
    )
  end
end
