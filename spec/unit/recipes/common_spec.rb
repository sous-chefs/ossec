require 'spec_helper'

describe 'ossec::common' do
  before do
    allow(File).to receive(:open).and_call_original
    allow(File).to receive(:open).with('/etc/ossec-init.conf')
  end

  cached(:chef_run) { ChefSpec::ServerRunner.new.converge('ossec::common') }
  let(:ossec_dir) { "ossec-hids-#{chef_run.node['ossec']['version']}" }

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
