#
# Cookbook:: websrv
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
# include_recipe '::filesystem'

# set the IP and chef server name
hostsfile_entry node['websrv']['chefsrv_ip'] do
  hostname 'chefsrv'
  action   :create
  unique   true
end

# set the IP and chef server name
hostsfile_entry node['websrv']['websrv_ip'] do
  hostname 'websrv'
  action   :create
  unique   true
end

# install dependencies
package node['websrv']['rhel']

# update and upgrade
execute 'yum_update_upgrade' do
  command 'sudo yum -y update && sudo yum -y upgrade'
end

# node.default['websrv']['common_name'] = 'websrv'
# node.default['websrv']['ssl_cert']['source'] = 'self-signed'
# node.default['websrv']['ssl_key']['source'] = 'self-signed'

# we need to save the resource variable to get the key and certificate file
# paths
# cert = ssl_certificate 'websrv' do
# we want to be able to use node['websrv'] to configure the certificate
#  namespace node['websrv']
#  notifies :restart, 'service[apache2]'
# end

# node.default['apache']['listen'] = ['*:443']
# include_recipe 'apache2'
# include_recipe 'apache2::mod_ssl'
apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'
# apache2_module 'ssl'

app_dir = '/var/www/basic_site'

directory app_dir do
  recursive true
end

# apache2_default_site 'websrv' do
#   default_site_name 'websrv'
#   cookbook 'websrv'
#   port '443'
#   template_source 'httpd.conf.erb'
#   action :enable
# end

# template '/etc/httpd/conf/httpd.conf' do
#   source 'httpd.conf.erb'
#   action :create
#   owner 'apache'
#   group 'apache'
#   mode '0644'
# end

# web_app 'websrv' do
#  cookbook 'ssl_certificate'
#  server_name cert.common_name
#  docroot '/var/www1'
#  ssl_key cert.key_path
#  ssl_cert cert.cert_path
#  # ssl_chain cert.chain_path
# end

# template "#{node['websrv']['www_dir']}/index.html" do
#   source 'index.html.erb'
#   action :create
#   owner 'apache'
#   group 'apache'
#   mode '0644'
# end

# node['websrv']['repos_list'].each do |rlist|
#  link "/var/www/html/#{rlist}" do
#    to "/media/sf_repos/#{rlist}"
#    owner 'apache'
#    group 'apache'
#  end
# end

# include_recipe 'vsftpd::default'

# sync RHEL repos
# execute 'rhel_sync' do
#   command "reposync \
# --gpgcheck \
# --plugins \
# --repoid=rhel-7-server-rpms \
# --repoid=rhel-7-server-extras-rpms \
# --download_path=#{node['websrv']['www_dir']}/html \
# --downloadcomps \
# --download-metadata"
#   only_if { File.exist?("#{node['websrv']['www_dir']}/html/rhel-7-server-rpms/comps.xml") }
#   only_if { File.exist?("#{node['websrv']['www_dir']}/html/rhel-7-server-extras-rpms/comps.xml") }
# end

# execute 'rhel_create_updates' do
#   command "createrepo -v #{node['websrv']['www_dir']}/html/rhel-7-server-rpms/ -g comps.xml"
#   only_if { File.exist?("#{node['websrv']['www_dir']}/html/rhel-7-server-rpms/comps.xml") }
# end
#
# execute 'rhel_create_extras' do
#   command "createrepo -v #{node['websrv']['www_dir']}/html/rhel-7-server-extras-rpms/ -g comps.xml"
#   only_if { File.exist?("#{node['websrv']['www_dir']}/html/rhel-7-server-extras-rpms/comps.xml") }
# end
#
# execute 'rsync_centos7_os' do
#   command "rsync -avzh rsync://mirror.umd.edu/centos/7/os/x86_64/ --exclude=debug --exclude=drpms --delete #{node['websrv']['centos7_dir']}/os"
#   only_if { Dir.exist?("#{node['websrv']['centos7_dir']}/os") }
# end
#
# execute 'rsync_centos7_updates' do
#   command "rsync -avzh rsync://mirror.umd.edu/centos/7/updates/x86_64/ --exclude=debug --exclude=drpms --delete #{node['websrv']['centos7_dir']}/updates"
#   only_if { Dir.exist?("#{node['websrv']['centos7_dir']}/updates") }
# end
#
# execute 'rsync_centos7_extras' do
#   command "rsync -avzh rsync://mirror.umd.edu/centos/7/extras/x86_64/ --exclude=debug --exclude=drpms --delete #{node['websrv']['centos7_dir']}/extras"
#   only_if { Dir.exist?("#{node['websrv']['centos7_dir']}/extras") }
# end
#
# execute 'rsync_epel7' do
#   command "rsync -avzh rsync://mirror.umd.edu/fedora/epel/7/x86_64/ --exclude=debug --exclude=drpms --delete #{node['websrv']['epel7_dir']}"
#   only_if { Dir.exist?(node['websrv']['epel7_dir']) }
# end
#
# template '/var/www/daily-rsync.sh' do
#   source 'daily-rsync.erb'
#   action :create
#   owner 'root'
#   group 'root'
#   mode '0754'
# end
#
# cron 'daily-repo-sync' do
#   minute  0
#   hour    21
#   command '/var/www/daily-rsync.sh'
#   user    'root'
# end

# change ip
# ifconfig node['websrv']['websrv_ip'] do
#   device 'enp0s8'
# end

# service 'apache2' do
#   action :start
# end
