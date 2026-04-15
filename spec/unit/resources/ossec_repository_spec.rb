# frozen_string_literal: true

require 'spec_helper'

describe 'ossec_repository' do
  step_into :ossec_repository

  context 'on ubuntu-24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      ossec_repository 'default'
    end

    it 'creates the apt repository' do
      expect(chef_run).to add_apt_repository('ossec')
    end
  end

  context 'on rockylinux-9' do
    platform 'rocky', '9'

    recipe do
      ossec_repository 'default'
    end

    it 'creates the yum repository' do
      expect(chef_run).to create_yum_repository('ossec')
    end
  end
end
