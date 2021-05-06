# websrv Cookbook

To serve files to my local cookbooks from local storage.
I needed this to work on Mac and Windows.

## Scope

TBD

## Requirements

The following environmental variables must be defined:<br>
  WEB_NAME = Name of the Web Server: websrv<br>
  WEB_RAM  = Ram of Server: 1024<br>
  WEB_CPU  = Number of CPUs: 1<br>
  WEB_IP   = IP address: 10.1.1.30<br>
  Chef_Release = The version of Chef Client to use<br>
  RepoDir = Full path directory on local system where the repos are stored<br>

### Platforms

- Redhat 7.x+
- CentOS 7.x+

### Chef

- Chef 13+

### Dependencies

- apache2
- hostsfile

## Usage

- recipe[websrv::no-ssl]

## Attributes

* default['websrv']['rhel'] - software packages this cookbook needs
* default['websrv']['chefsrv_ip'] - The IP address of my local Chef Server
* default['websrv']['websrv_ip'] - The IP address of this Server

## Custom Resources

None
