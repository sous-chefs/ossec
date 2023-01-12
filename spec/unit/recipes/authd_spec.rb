require 'spec_helper'
require 'json'

describe 'ossec::authd' do
  before do
    allow(File).to receive(:open).and_call_original
    allow(File).to receive(:open).with('/etc/ossec-init.conf')
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/var/ossec/etc/sslmanager.cert').and_return(true)
    allow(File).to receive(:exist?).with('/var/ossec/etc/sslmanager.key').and_return(true)
  end

  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge('ossec::authd')
  end

  it 'includes ossec::install_server recipe' do
    expect(chef_run).to include_recipe('ossec::install_server')
  end

  it 'includes ossec::common recipe' do
    expect(chef_run).to include_recipe('ossec::common')
  end

  context 'systemd' do
    it 'setup ossec-authd.service' do
      expect(chef_run).to create_template('ossec-authd init')
    end

    it 'reload systemctl' do
      execute = chef_run.execute('systemctl daemon-reload')
      expect(execute).to subscribe_to('template[ossec-authd init]').on(:run).immediately
    end
  end

  it 'enable & start ossec-authd service' do
    expect(chef_run).to enable_service('ossec-authd')
    expect(chef_run).to start_service('ossec-authd')
  end
end
