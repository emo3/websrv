default['websrv']['rhel'] =
  if node['platform_version'] < '8'
    %w(yum-utils createrepo rsync bind-utils)
  else
    %w(dnf-utils createrepo_c rsync bind-utils)
  end
default['websrv']['chefsrv_ip']  = '10.1.1.10'
default['websrv']['websrv_ip']   = '10.1.1.30'
