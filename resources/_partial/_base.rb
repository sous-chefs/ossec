# frozen_string_literal: true

property :install_dir, String, default: '/var/ossec'
property :data_bag_name, String, default: 'ossec'
property :ssh_data_bag_item, String, default: 'ssh'
property :encrypted_data_bag, [true, false], default: false
property :ossec_conf, Hash, default: {}
property :agent_conf, Array, default: []
property :manage_repository, [true, false], default: true
