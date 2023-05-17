name 'websrv'
source_url       'https://github.com/emo3/websrv'
issues_url       'https://github.com/emo3/websrv/issues'
maintainer       'Ed Overton'
maintainer_email 'you1@example.com'
chef_version     '>= 15'
license          'Apache-2.0'
description      'Installs/Configures websrv'
version          '1.7.0'

supports 'redhat'
supports 'centos'
supports 'almalinux'

depends 'apache2', '~> 8' # keep at version 8 until I can fix for 9+
depends 'line'
