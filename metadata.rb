name 'rwebsrv'
maintainer 'Ed Overton'
maintainer_email 'infuse.1301@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures rwebsrv'
long_description 'Installs/Configures rwebsrv'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'redhat'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/rwebsrv/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/rwebsrv'
depends 'apache2'
depends 'hostsfile'
depends 'lvm'
depends 'vsftpd'
depends 'redhat_subscription_manager'
