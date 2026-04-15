# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_authd' do
  step_into :ossec_authd
  platform 'ubuntu', '24.04'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/sslmanager.cert').and_return(true)
    allow(File).to receive(:exist?).with('/var/ossec/etc/sslmanager.key').and_return(true)
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(true)
    allow(File).to receive(:empty?).and_call_original
    allow(File).to receive(:empty?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  recipe do
    ossec_authd 'default'
  end

  it 'creates the authd unit' do
    expect(chef_run).to create_systemd_unit('ossec-authd.service')
  end
end
