# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_agent_auth' do
  step_into :ossec_agent_auth
  platform 'ubuntu', '24.04'

  before do
    allow(File).to receive(:size?).and_call_original
    allow(File).to receive(:size?).with('/var/ossec/etc/client.keys').and_return(nil)
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/client.keys').and_return(false)
  end

  recipe do
    ossec_agent_auth 'default' do
      agent_server_ip '192.0.2.10'
    end
  end

  it 'runs agent-auth' do
    expect(chef_run).to run_execute('ossec-agent-auth')
  end
end
