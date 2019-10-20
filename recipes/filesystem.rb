#######################################
# Create base agent directory
directory node['websrv']['www_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

#######################################
# Set physical volume
lvm_physical_volume '/dev/sdb'

#######################################
# Set volume group
lvm_volume_group node['websrv']['lvg_name'] do
  physical_volumes ['/dev/sdb']
end

#######################################
# Set logical volume
lvm_logical_volume node['websrv']['lvol'] do
  group node['websrv']['lvg_name']
  size '80G'
  filesystem 'xfs'
  mount_point node['websrv']['www_dir']
end

#######################################
# Set /tmp to 3G, from the original 1.99 provided by build.
# APM needs minimum of 2G
lvm_logical_volume 'lvtmp' do
  group 'rootvg'
  size '6G'
  filesystem 'xfs'
  mount_point node['websrv']['temp_dir']
  # action :resize
  action :nothing
end

# create www dir
directory node['websrv']['www_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end
