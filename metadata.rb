name 'websrv'
source_url       'https://github.com/emo3/websrv'
issues_url       'https://github.com/emo3/websrv/issues'
maintainer       'Ed Overton'
maintainer_email 'you@example.com'
chef_version     '>= 13.9'
license          'Apache-2.0'
description      'Installs/Configures websrv'
version          '1.4.2'

supports 'redhat'
supports 'centos'

depends 'apache2'
depends 'hostsfile'
