name             'ossec'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
source_url       'https://github.com/sous-chefs/ossec'
issues_url       'https://github.com/sous-chefs/ossec'
description      'Installs and configures ossec'
version          '1.2.7'
chef_version     '>= 16.13'

depends 'yum-atomic'

%w( debian ubuntu redhat centos fedora scientific oracle amazon ).each do |os|
  supports os
end
