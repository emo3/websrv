name 'build_cookbook'
maintainer 'Ed Overton'
maintainer_email 'infuse.1301@gmail.com'
license 'Apache 2.0'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
depends 'delivery-truck'