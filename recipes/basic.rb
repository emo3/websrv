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

app_dir = '/var/www/html'
directory app_dir do
  extend    Apache2::Cookbook::Helpers
  recursive true
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
end

## Add this section of code only when testing
# file "#{app_dir}/index.html" do
#   content 'Hello World'
#   extend  Apache2::Cookbook::Helpers
#   owner   lazy { default_apache_user }
#   group   lazy { default_apache_group }
# end

site_name = 'no-ssl'
apache2_default_site site_name do
  default_site_name site_name
  template_cookbook 'websrv'
  template_source "#{site_name}.conf.erb"
  variables(
    server_name: node['websrv']['websrv_ip'],
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name
  )
end

apache2_site site_name
