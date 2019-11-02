default['websrv']['repos_list']  = %w(centos7 epel7 media)
default['websrv']['centos7_dir'] = "#{node['websrv']['local_dir']}/centos7"
default['websrv']['epel7_dir']   = "#{node['websrv']['local_dir']}/epel7"
default['websrv']['rhel']        = %w(yum-utils createrepo rsync bind-utils)
default['websrv']['chefsrv_ip']  = '10.1.1.10'
default['websrv']['websrv_ip']   = '10.1.1.30'
