# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_local' do
  step_into %i(ossec_local ossec_install ossec_config ossec_repository)
  platform 'ubuntu', '24.04'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(true)
    allow(File).to receive(:empty?).and_call_original
    allow(File).to receive(:empty?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  recipe do
    ossec_local 'default'
  end

  it 'installs the server package' do
    expect(chef_run).to install_package('ossec-hids-server')
  end

  it 'creates ossec.conf' do
    expect(chef_run).to create_file('/var/ossec/etc/ossec.conf')
  end
end
