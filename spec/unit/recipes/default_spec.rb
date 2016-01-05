require 'spec_helper'

describe 'ossec::default' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge('ossec::default') }
  let(:ossec_dir) { "ossec-hids-#{chef_run.node['ossec']['version']}" }

  it 'includes build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential')
  end

  it 'creates ossec remote_file' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/#{ossec_dir}.tar.gz").with(
      source: chef_run.node['ossec']['url'],
      checksum: chef_run.node['ossec']['checksum']
    )
  end

  it 'executes untar on ossec tar.gz file' do
    expect(chef_run).to run_execute("tar zxvf #{ossec_dir}.tar.gz").with(
      cwd: Chef::Config[:file_cache_path],
      creates: "#{Chef::Config[:file_cache_path]}/#{ossec_dir}"
    )
  end

  it 'creates preloaded-vars.conf template' do
    expect(chef_run).to create_template("#{Chef::Config[:file_cache_path]}/#{ossec_dir}/etc/preloaded-vars.conf").with(
      source: 'preloaded-vars.conf.erb'
    )
  end

  it 'runs bash install-ossec' do
    expect(chef_run).to run_bash('install-ossec')
  end

  it 'creates ossec-batch-manager.pl template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['user']['dir']}/bin/ossec-batch-manager.pl").with(
      source: "#{Chef::Config[:file_cache_path]}/#{ossec_dir}/contrib/ossec-batch-manager.pl",
      local: true,
      owner: 'root',
      group: 'ossec',
      mode: 0755
    )
  end

  it 'creates ossec.conf template' do
    expect(chef_run).to create_template("#{chef_run.node['ossec']['user']['dir']}/etc/ossec.conf").with(
      source: 'ossec.conf.erb',
      owner: 'root',
      group: 'ossec',
      mode: 0440
    )
  end

  it 'enables ossec service' do
    expect(chef_run).to enable_service('ossec')
  end

  it 'starts ossec service' do
    expect(chef_run).to start_service('ossec')
  end

  context 'Arch Linux platform' do
    let(:chef_run_arch) do
      ChefSpec::ServerRunner.new(platform: 'arch', version: '3.10.5-1-ARCH').converge('ossec::default')
    end

    it 'creates ossec.service template' do
      expect(chef_run_arch).to create_template('/usr/lib/systemd/system/ossec.service')
    end
  end
end
