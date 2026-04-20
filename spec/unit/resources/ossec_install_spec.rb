# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_install' do
  step_into %i(ossec_install ossec_repository)
  platform 'ubuntu', '24.04'

  recipe do
    ossec_install 'server'
  end

  it 'installs the server package' do
    expect(chef_run).to install_package('ossec-hids-server')
  end

  it 'configures the package repository' do
    expect(chef_run).to add_apt_repository('ossec')
  end
end
