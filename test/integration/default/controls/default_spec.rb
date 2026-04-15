# frozen_string_literal: true

require_relative '../../spec_helper'

control 'ossec-default-package-01' do
  impact 1.0
  title 'The server package is installed'

  describe package('ossec-hids-server') do
    it { should be_installed }
  end
end

control 'ossec-default-config-01' do
  impact 0.7
  title 'The main OSSEC configuration exists'

  describe file('/var/ossec/etc/ossec.conf') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'ossec' }
  end
end

control 'ossec-default-service-01' do
  impact 0.5
  title 'The main service unit is present'

  describe systemd_service(ossec_service_name) do
    it { should be_installed }
  end
end
