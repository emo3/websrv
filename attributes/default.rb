default['rwebsrv']['local_dir']  = '/media/sf_repos'
default['rwebsrv']['www_dir']    = '/var/www/html'
default['rwebsrv']['repos_list'] = [
  'centos7',
  'rhel-7-server-rpms',
  'rhel-7-server-extras-rpms',
  'epel7',
  'media',
]
default['rwebsrv']['centos7_dir'] = "#{node['rwebsrv']['local_dir']}/centos7"
default['rwebsrv']['epel7_dir']   = "#{node['rwebsrv']['local_dir']}/epel7"
default['rwebsrv']['lvol']        = 'lvwww'
default['rwebsrv']['lvg_name']    = 'apmvg'
default['rwebsrv']['rhel']        = %w(yum-utils createrepo rsync subscription-manager)
default['rwebsrv']['repo_stat']   = '1'
default['rwebsrv']['chefsrv_ip']  = '10.1.1.10'
default['rwebsrv']['cwebsrv_ip']  = '10.1.1.30'
default['rwebsrv']['nwebsrv_ip']  = '10.1.1.31'
default['rwebsrv']['temp_dir']    = '/tmp'
