default['websrv']['local_dir']  = '/media/sf_repos'
default['websrv']['www_dir']    = '/var/www/html'
default['websrv']['repos_list'] = [
  'centos7',
  'epel7',
  'media',
]
default['websrv']['centos7_dir'] = "#{node['websrv']['local_dir']}/centos7"
default['websrv']['epel7_dir']   = "#{node['websrv']['local_dir']}/epel7"
default['websrv']['lvol']        = 'weblv'
default['websrv']['lvg_name']    = 'webvg'
default['websrv']['rhel']        = %w(yum-utils createrepo rsync subscription-manager)
default['websrv']['repo_stat']   = '1'
default['websrv']['chefsrv_ip']  = '10.1.1.10'
default['websrv']['websrv_ip']   = '10.1.1.30'
default['websrv']['temp_dir']    = '/tmp'
