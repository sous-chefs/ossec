name             'ossec'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs and configures ossec'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.0'
chef_version     '>= 13.0'

depends 'yum-atomic'

%w( debian ubuntu redhat centos fedora scientific oracle amazon ).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/ossec'
issues_url 'https://github.com/sous-chefs/ossec'
