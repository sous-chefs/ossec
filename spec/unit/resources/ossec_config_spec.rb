# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_config' do
  step_into :ossec_config
  platform 'ubuntu', '24.04'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(true)
    allow(File).to receive(:empty?).and_call_original
    allow(File).to receive(:empty?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  recipe do
    ossec_config 'local'
  end

  it 'creates ossec.conf' do
    expect(chef_run).to create_file('/var/ossec/etc/ossec.conf')
  end

  it 'creates agent.conf' do
    expect(chef_run).to create_file('/var/ossec/etc/shared/agent.conf')
  end
end

describe 'ossec_config on rockylinux-9' do
  step_into :ossec_config
  platform 'rocky', '9'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(true)
    allow(File).to receive(:empty?).and_call_original
    allow(File).to receive(:empty?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  recipe do
    ossec_config 'local'
  end

  it 'does not include unsupported use_geoip in ossec.conf' do
    expect(chef_run.file('/var/ossec/etc/ossec.conf').content).not_to include('use_geoip')
  end
end
