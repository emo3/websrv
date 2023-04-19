app_dir = '/var/www/html'

# set the IP and web server name
append_if_no_line 'websrv' do
  path '/etc/hosts'
  line "#{node['websrv']['websrv_ip']} websrv"
end

# install dependencies
package node['websrv']['rhel']

apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action :nothing
end

apache2_module 'deflate'
apache2_module 'headers'
apache2_module 'ssl'

apache2_mod_ssl ''

directory app_dir do
  extend    Apache2::Cookbook::Helpers
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

# file "#{app_dir}/index.html" do
#   content 'Hello World'
#   extend  Apache2::Cookbook::Helpers
#   owner   lazy { default_apache_user }
#   group   lazy { default_apache_group }
# end

include_recipe 'acme'

# Real certificates please...
# node.override['acme']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'

site = 'websrv.local'
# sans = ["www.#{site}"]

# Generate a self-signed if we don't have a cert to prevent bootstrap problems
acme_selfsigned "#{site}" do
  crt     "#{apache_dir}/ssl/#{site}.crt"
  key     "#{apache_dir}/ssl/#{site}.key"
  chain   "#{apache_dir}/ssl/#{site}.pem"
  owner   'apache'
  group   'apache'
  notifies :restart, 'service[apache2]', :immediately
end

# Set up your web server here...
apache2_default_site site do
  default_site_name site
  template_cookbook 'websrv'
  template_source 'ssl.conf.erb'
  variables(
    server_name: node['websrv']['websrv_ip'],
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    ssl_cert_file: "#{apache_dir}/ssl/#{site}.crt",
    ssl_cert_key_file: "#{apache_dir}/ssl/#{site}.key"
  )
end

apache2_site site

# # Get and auto-renew the certificate from Let's Encrypt
# acme_certificate "#{site}" do
#   crt               "#{apache_dir}/ssl/#{site}.crt"
#   key               "#{apache_dir}/ssl/#{site}.key"
#   wwwroot           app_dir
#   notifies :restart, 'service[apache2]'
#   alt_names sans
# end
