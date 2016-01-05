require 'spec_helper'
require 'json'

describe 'ossec::wui' do
  let(:ossec_wui_dir) { "ossec-wui-#{chef_run.node['ossec']['wui']['version']}" }
  let(:data_bags_path) { File.expand_path('../../../../test/integration/default/data_bags', __FILE__) }
  let(:data_bag_users_ossec) { JSON.parse(File.read("#{data_bags_path}/users/ossec.json")) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    www_node = stub_node(platform: 'ubuntu', version: '14.04') do |node|
      node.set['ipaddress'] = '33.33.33.33'
      node.set['fqdn']      = 'chefspec_client.local'
    end

    ChefSpec::ServerRunner.new do |_node, server|
      server.create_node(www_node, run_list: ['ossec'])
      server.create_data_bag('users', 'ossec' => data_bag_users_ossec)
      server.create_data_bag('ossec', 'ssh' => data_bag_users_ossec)
    end.converge('ossec::wui')
  end

  before(:each) do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command("grep 'chefspec.local 127.0.0.1' /var/ossec/etc/client.keys").and_return(true)
    stub_command("grep 'fauxhai.local 10.0.0.2' /var/ossec/etc/client.keys").and_return(true)
  end

  it 'includes apache2 recipe' do
    expect(chef_run).to include_recipe('apache2')
  end

  it 'includes apache2::mod_php5 recipe' do
    expect(chef_run).to include_recipe('apache2::mod_php5')
  end

  it 'includes ossec::client recipe' do
    expect(chef_run).to include_recipe('ossec::server')
  end

  it 'creates ossec group' do
    expect(chef_run).to create_group('ossec').with(members: [chef_run.node['apache']['group']])
  end

  it 'creates apache_doc_root directory' do
    expect(chef_run).to create_directory("#{chef_run.node['apache']['dir']}/htdocs")
  end

  it 'creates ossec_wui remotefile' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/#{ossec_wui_dir}.tar.gz")
  end

  it 'runs bash unpackage-ossec-wui' do
    expect(chef_run).to run_bash('unpackage-ossec-wui')
  end

  it 'creates ossec apache dir' do
    expect(chef_run).to create_directory("#{chef_run.node['apache']['dir']}/ossec")
  end

  describe 'ossec-wui htaccess template' do
    let(:wui_htaccess_template) { "#{chef_run.node['apache']['dir']}/htdocs/ossec-wui/.htaccess" }

    it 'creates ossec-wui htaccess template' do
      expect(chef_run).to create_template(wui_htaccess_template).with(
        source: 'htaccess.erb',
        owner: chef_run.node['apache']['user'],
        group: chef_run.node['apache']['group']
      )
    end

    it 'sends restart notification to apache2' do
      expect(chef_run.template(wui_htaccess_template)).to notify('service[apache2]').to(:restart)
    end
  end

  describe 'ossec htpasswd template' do
    let(:ossec_htpasswd_template) { "#{chef_run.node['apache']['dir']}/ossec/.htpasswd" }

    it 'creates ossec htpasswd template' do
      expect(chef_run).to create_template(ossec_htpasswd_template).with(
        source: 'htpasswd.erb',
        owner: chef_run.node['apache']['user'],
        group: chef_run.node['apache']['group']
      )
    end

    it 'sends restart notification to apache2' do
      expect(chef_run.template(ossec_htpasswd_template)).to notify('service[apache2]').to(:restart)
    end
  end
end
