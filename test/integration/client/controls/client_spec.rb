# frozen_string_literal: true

control 'ossec-client-package-01' do
  impact 1.0
  title 'The client package is installed'

  describe package('ossec-hids-agent') do
    it { should be_installed }
  end
end

control 'ossec-client-ssh-01' do
  impact 0.7
  title 'The SSH authorization file exists for agent key distribution'

  describe file('/var/ossec/.ssh/authorized_keys') do
    it { should exist }
    its('owner') { should eq 'ossec' }
    its('group') { should eq 'ossec' }
  end
end

control 'ossec-client-keys-01' do
  impact 0.7
  title 'The client keys file exists'

  describe file('/var/ossec/etc/client.keys') do
    it { should exist }
    its('owner') { should eq 'ossec' }
    its('group') { should eq 'ossec' }
  end
end
