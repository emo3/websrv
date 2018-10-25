#
# Cookbook:: rwebsrv
# Recipe:: default
#
# Copyright:: 2017, Ed Overton, Apache 2.0
include_recipe '::filesystem'

# set the IP and chef server name
hostsfile_entry node['rwebsrv']['chefsrv_ip'] do
  hostname 'chefsrv'
  action   :create
  unique   true
end

# Add internet mirror
yum_repository 'CentOS-Base' do
  description 'CentOS-7.x - Base'
  mirrorlist 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra'
  # baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
  gpgcheck true
  gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
  enabled true
  action :create
  make_cache false
  only_if { node['platform'] == 'centos' }
end

# install dependencies
package node['rwebsrv']['rhel']

# delete current yum repository's
yum_repository 'centos7' do
  action :delete
  only_if { node['platform'] == 'centos' }
end

yum_repository 'rhel7' do
  action :delete
  only_if { node['platform'] == 'redhat' }
end

# Delete old registration
rhsm_register 'rwebsrv' do
  organization '8039968'
  activation_key 'emo3-rhel-akey'
  action :unregister
  only_if { node['platform'] == 'redhat' }
end

# add box to RHSM
rhsm_register 'rwebsrv' do
  organization '8039968'
  activation_key 'emo3-rhel-akey'
  action :register
  auto_attach true
  install_katello_agent false
  only_if { node['platform'] == 'redhat' }
end

rhsm_repo 'rhel-7-server-rpms' do
  action :enable
  only_if { node['platform'] == 'redhat' }
end

# update and upgrade
execute 'yum_update_upgrade' do
  command 'sudo yum -y update && sudo yum -y upgrade'
end

# node.default['rwebsrv']['common_name'] = 'rwebsrv'
# node.default['rwebsrv']['ssl_cert']['source'] = 'self-signed'
# node.default['rwebsrv']['ssl_key']['source'] = 'self-signed'

# we need to save the resource variable to get the key and certificate file
# paths
# cert = ssl_certificate 'rwebsrv' do
# we want to be able to use node['rwebsrv'] to configure the certificate
#  namespace node['rwebsrv']
#  notifies :restart, 'service[apache2]'
# end

# node.default['apache']['listen'] = ['*:443']
include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  action :create
  owner 'apache'
  group 'apache'
  mode '0644'
end

# web_app 'rwebsrv' do
#  cookbook 'ssl_certificate'
#  server_name cert.common_name
#  docroot '/var/www1'
#  ssl_key cert.key_path
#  ssl_cert cert.cert_path
#  # ssl_chain cert.chain_path
# end

template "#{node['rwebsrv']['www_dir']}/html/index.html" do
  source 'index.html.erb'
  action :create
  owner 'apache'
  group 'apache'
  mode '0644'
end

node['rwebsrv']['repos_dir'].each do |repo|
  directory repo do
    action :create
    owner 'apache'
    group 'apache'
    mode '0755'
  end
end

include_recipe 'vsftpd::default'

# sync RHEL repos
execute 'rhel_sync' do
  command "reposync \
--gpgcheck \
--plugins \
--repoid=rhel-7-server-rpms \
--repoid=rhel-7-server-extras-rpms \
--download_path=#{node['rwebsrv']['www_dir']}/html \
--downloadcomps \
--download-metadata"
  only_if { node['platform'] == 'redhat' }
  only_if { File.exist?("#{node['rwebsrv']['www_dir']}/html/rhel-7-server-rpms/comps.xml") }
  only_if { File.exist?("#{node['rwebsrv']['www_dir']}/html/rhel-7-server-extras-rpms/comps.xml") }
end

execute 'rhel_create_updates' do
  command "createrepo -v #{node['rwebsrv']['www_dir']}/html/rhel-7-server-rpms/ -g comps.xml"
  only_if { File.exist?("#{node['rwebsrv']['www_dir']}/html/rhel-7-server-rpms/comps.xml") }
  only_if { node['platform'] == 'redhat' }
end

execute 'rhel_create_extras' do
  command "createrepo -v #{node['rwebsrv']['www_dir']}/html/rhel-7-server-extras-rpms/ -g comps.xml"
  only_if { File.exist?("#{node['rwebsrv']['www_dir']}/html/rhel-7-server-extras-rpms/comps.xml") }
  only_if { node['platform'] == 'redhat' }
end

# Put back local repo
template '/etc/yum.repos.d/centos7.repo' do
  source 'centos7.repo.erb'
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  only_if { node['platform'] == 'centos' }
end

# Delete internet repo
yum_repository 'CentOS-Base' do
  action :delete
  only_if { node['platform'] == 'centos' }
end

execute 'rsync_centos_os' do
  command "rsync -avzh rsync://mirror.umd.edu/centos/7/os/x86_64/ --exclude=debug --exclude=drpms --delete #{node['rwebsrv']['centos_dir']}/os"
  only_if { Dir.exist?("#{node['rwebsrv']['centos_dir']}/os") }
end

execute 'rsync_centos_updates' do
  command "rsync -avzh rsync://mirror.umd.edu/centos/7/updates/x86_64/ --exclude=debug --exclude=drpms --delete #{node['rwebsrv']['centos_dir']}/updates"
  only_if { Dir.exist?("#{node['rwebsrv']['centos_dir']}/updates") }
end

execute 'rsync_centos_extras' do
  command "rsync -avzh rsync://mirror.umd.edu/centos/7/extras/x86_64/ --exclude=debug --exclude=drpms --delete #{node['rwebsrv']['centos_dir']}/extras"
  only_if { Dir.exist?("#{node['rwebsrv']['centos_dir']}/extras") }
end

execute 'rsync_epel7' do
  command "rsync -avzh rsync://mirror.umd.edu/fedora/epel/7/x86_64/ --exclude=debug --exclude=drpms --delete #{node['rwebsrv']['www_dir']}/html/epel7"
  only_if { Dir.exist?(node['rwebsrv']['epel_dir']) }
end

template '/var/www/daily-rsync.sh' do
  source 'daily-rsync.erb'
  action :create
  owner 'root'
  group 'root'
  mode '0754'
end

cron 'daily-repo-sync' do
  minute  0
  hour    21
  command '/var/www/daily-rsync.sh'
  user    'root'
end

# change ip
ifconfig node['rwebsrv']['websrv_ip'] do
  device 'enp0s8'
end
