require 'spec_helper'

describe 'ossec::common' do
  cached(:chef_run) { ChefSpec::ServerRunner.new.converge('ossec::common') }
  let(:ossec_dir) { "ossec-hids-#{chef_run.node['ossec']['version']}" }

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
