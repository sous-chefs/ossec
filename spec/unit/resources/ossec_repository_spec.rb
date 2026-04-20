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

  context 'on debian-13' do
    platform 'debian', '13'

    recipe do
      ossec_repository 'default'
    end

    it 'creates the apt repository as trusted' do
      expect(chef_run).to add_apt_repository('ossec').with(trusted: true)
    end
  end

  context 'on debian-12' do
    platform 'debian', '12'

    recipe do
      ossec_repository 'default'
    end

    it 'creates the apt repository without trusted mode' do
      expect(chef_run).to add_apt_repository('ossec').with(trusted: false)
    end
  end

  context 'on amazonlinux-2023' do
    platform 'amazon', '2023'

    recipe do
      ossec_repository 'default'
    end

    it 'uses the Amazon Linux repository path' do
      expect(chef_run).to create_yum_repository('ossec').with(
        baseurl: 'https://updates.atomicorp.com/channels/atomic/amazon/2023/$basearch'
      )
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
