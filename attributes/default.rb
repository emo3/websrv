default['websrv'].tap do |wsrv|
  wsrv['rhel'] =
  if node['platform_version'] < '8'
    %w(yum-utils createrepo rsync bind-utils)
  else
    %w(yum-utils dnf-plugins-core rsync)
  end
  wsrv['websrv_ip'] = '10.1.1.30'
end
