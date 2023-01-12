require 'spec_helper'
require 'json'

describe 'ossec::agent' do
  before do
    allow(File).to receive(:open).and_call_original
    allow(File).to receive(:open).with('/etc/ossec-init.conf')
  end

  let(:data_bags_path) { File.expand_path('../../../test/fixtures/data_bags', __dir__) }
  let(:data_bag_ossec_ssh) { JSON.parse(File.read("#{data_bags_path}/ossec/ssh.json")) }

  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |_node, server|
      server.create_data_bag('ossec', 'ssh' => data_bag_ossec_ssh)
    end.converge('ossec::agent')
  end

  it 'includes ossec::client recipe' do
    expect(chef_run).to include_recipe('ossec::client')
  end
end
