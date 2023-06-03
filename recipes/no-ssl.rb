# set the IP and web server name
append_if_no_line 'websrv' do
  path '/etc/hosts'
  line "#{node['websrv']['websrv_ip']} websrv"
end

# install dependencies
package node['websrv']['rhel']

apache2_install 'default' do
  notifies :restart, 'apache2_service[default]'
end

apache2_module 'deflate' do
  notifies :reload, 'apache2_service[default]'
end

apache2_module 'headers' do
  notifies :reload, 'apache2_service[default]'
end

app_dir = '/var/www/html'

directory app_dir do
  recursive true
  owner lazy { default_apache_user }
  group lazy { default_apache_group }
end

## Add this section of code only when testing
# file "#{app_dir}/index.html" do
#   content 'Hello World'
#   owner   lazy { default_apache_user }
#   group   lazy { default_apache_group }
# end

# Create site template with our custom config
site_name = 'no_ssl'
apache2_default_site site_name do
  default_site_name site_name
  template_cookbook 'websrv'
  template_source 'no-ssl.conf.erb'
  variables(
    server_name: node['websrv']['websrv_ip'],
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name
  )
  notifies :reload, 'apache2_service[default]'
end

apache2_service 'default' do
  action %i(enable start)
end
