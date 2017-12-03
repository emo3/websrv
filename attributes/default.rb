default['rwebsrv']['www_dir']    = '/var/www'
default['rwebsrv']['centos_dir'] = "#{node['rwebsrv']['www_dir']}/html/centos7"
default['rwebsrv']['rdvd_dir']   = "#{node['rwebsrv']['www_dir']}/html/r7dvdrepo"
default['rwebsrv']['rhel_u_dir'] = "#{node['rwebsrv']['www_dir']}/html/rhel-7-server-rpms"
default['rwebsrv']['rhel_x_dir'] = "#{node['rwebsrv']['www_dir']}/html/rhel-7-server-extras-rpms"
default['rwebsrv']['epel_dir']   = "#{node['rwebsrv']['www_dir']}/html/epel7"
default['rwebsrv']['media_dir']  = "#{node['rwebsrv']['www_dir']}/html/media"
default['rwebsrv']['repos_dir']  = [
  node['rwebsrv']['centos_dir'],
  node['rwebsrv']['rdvd_dir'],
  node['rwebsrv']['rhel_u_dir'],
  node['rwebsrv']['rhel_x_dir'],
  node['rwebsrv']['epel_dir'],
  node['rwebsrv']['media_dir'],
]
default['rwebsrv']['lvol']       = 'lvwww'
default['rwebsrv']['volg']       = 'apmvg'
default['rwebsrv']['rhel']       = %w(yum-utils createrepo rsync subscription-manager)
default['rwebsrv']['repo_stat']  = '1'
default['chefsrv_ip']            = '10.1.1.10'
default['websrv_ip']             = '10.1.1.30'
default['temp_dir']              = '/tmp'
