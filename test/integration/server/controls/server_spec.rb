# frozen_string_literal: true

control 'ossec-server-package-01' do
  impact 1.0
  title 'The server package is installed'

  describe package('ossec-hids-server') do
    it { should be_installed }
  end
end

control 'ossec-server-distribution-01' do
  impact 0.7
  title 'The server key distribution script is present'

  describe file('/usr/local/bin/dist-ossec-keys.sh') do
    it { should exist }
    its('mode') { should cmp '0755' }
  end
end

control 'ossec-server-ssh-01' do
  impact 0.7
  title 'The server private key file exists'

  describe file('/var/ossec/.ssh/id_rsa') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'ossec' }
  end
end
