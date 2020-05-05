name             'ossec'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures ossec'

version          '1.2.1'
chef_version     '>= 13.0'

depends 'yum-atomic'

%w( debian ubuntu redhat centos fedora scientific oracle amazon ).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/ossec'
issues_url 'https://github.com/sous-chefs/ossec'
