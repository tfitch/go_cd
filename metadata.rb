name             'go_cd'
maintainer       'Ranjib Dey'
maintainer_email 'ranjib@linuxc.com'
license          'All rights reserved'
description      'Installs/Configures go-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3'
source_url 'https://github.com/GoatOS/go_cd'
issues_url 'https://github.com/GoatOS/go_cd/issues'
recipe 'go_cd::server', 'Install GoCD server'
recipe 'go_cd::agent', 'Install GoCD agent'
depends 'apt'
