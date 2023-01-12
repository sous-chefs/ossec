require 'spec_helper'
require 'json'

describe 'ossec::server' do
  let(:data_bags_path) { File.expand_path('../../../test/fixtures/data_bags', __dir__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    www_node = stub_node(platform: 'ubuntu', version: '18.04') do |node|
      node.normal['ipaddress'] = '33.33.33.33'
      node.normal['fqdn']      = 'chefspec_client.local'
    end

    ChefSpec::ServerRunner.new do |_node, server|
      server.create_node(www_node, run_list: ['ossec'])
      server.create_data_bag('ossec', 'ssh' => data_bag_ossec_ssh)
    end.converge('ossec::server')
  end

  before(:each) do
    stub_command("grep 'chefspec.local 127.0.0.1' /var/ossec/etc/client.keys").and_return(true)
    stub_command("grep 'fauxhai.local 10.0.0.2' /var/ossec/etc/client.keys").and_return(true)
  end

  it 'includes ossec::install_server recipe' do
    expect(chef_run).to include_recipe('ossec::install_server')
  end

  it 'includes ossec::repository recipe' do
    expect(chef_run).to include_recipe('ossec::repository')
  end

  it 'includes ossec::common recipe' do
    expect(chef_run).to include_recipe('ossec::repository')
  end

  it 'installs the server package' do
    expect(chef_run).to install_package('ossec-hids-server')
  end

  it 'creates ossec user .ssh directory' do
    expect(chef_run).to create_directory("#{chef_run.node['ossec']['dir']}/.ssh").with(
      owner: 'root',
      group: 'ossec',
      mode: '0750'
    )
  end

  it 'creates ossec ssh id_rsa key template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['dir']}/.ssh/id_rsa").with(
      source: 'ssh_key.erb',
      owner: 'root',
      group: 'ossec',
      mode: '0600'
    )
  end
end
