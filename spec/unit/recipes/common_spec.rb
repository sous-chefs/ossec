require 'spec_helper'

describe 'ossec::common' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge('ossec::common') }
  let(:ossec_dir) { "ossec-hids-#{chef_run.node['ossec']['version']}" }

  it 'creates preloaded-vars.conf template' do
    expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/#{ossec_dir}/etc/preloaded-vars.conf").with(
      source: 'preloaded-vars.conf.erb'
    )
  end

  it 'creates ossec-batch-manager.pl template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['dir']}/bin/ossec-batch-manager.pl").with(
      source: "#{Chef::Config[:file_cache_path]}/#{ossec_dir}/contrib/ossec-batch-manager.pl",
      local: true,
      owner: 'root',
      group: 'ossec',
      mode: '0755'
    )
  end

  it 'creates ossec.conf template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['dir']}/etc/ossec.conf").with(
      source: 'ossec.conf.erb',
      owner: 'root',
      group: 'ossec',
      mode: '0440'
    )
  end

  it 'enables ossec service' do
    expect(chef_run).to enable_service('ossec')
  end

  it 'starts ossec service' do
    expect(chef_run).to start_service('ossec')
  end
end
