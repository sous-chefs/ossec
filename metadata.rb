# frozen_string_literal: true

name             'ossec'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
source_url       'https://github.com/sous-chefs/ossec'
issues_url       'https://github.com/sous-chefs/ossec/issues'
description      'Provides custom resources for managing OSSEC HIDS packages and configuration'
version          '2.0.18'
chef_version     '>= 15.3'

supports 'amazon', '>= 2023.0'
supports 'debian', '>= 12.0'
supports 'rocky', '>= 9.0'
supports 'ubuntu', '>= 22.04'
