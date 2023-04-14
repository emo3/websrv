app_dir = '/var/www/html'

# set the IP and web server name
append_if_no_line 'websrv' do
  path '/etc/hosts'
  line "#{node['websrv']['websrv_ip']} websrv"
end

# install dependencies
package node['websrv']['rhel']

# ::Chef::DSL::Recipe.send(:include, Apache2)

apache2_install 'default'

service 'apache2' do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'deflate'
apache2_module 'headers'

directory app_dir do
  extend    Apache2::Cookbook::Helpers
  owner     lazy { default_apache_user }
  group     lazy { default_apache_group }
  recursive true
end

## Add this section of code only when testing
# file "#{app_dir}/index.html" do
#   content 'Hello World'
#   extend  Apache2::Cookbook::Helpers
#   owner   lazy { default_apache_user }
#   group   lazy { default_apache_group }
# end

# Create site template with our custom config
site_name = 'no_ssl'

template site_name do
  extend Apache2::Cookbook::Helpers
  source 'no-ssl.conf.erb'
  path "#{apache_dir}/sites-available/#{site_name}.conf"
  variables(
    server_name: node['websrv']['websrv_ip'],
    # server_name: 'example.com',
    document_root: app_dir,
    log_dir: lazy { default_log_dir },
    site_name: site_name
  )
end

apache2_site site_name
