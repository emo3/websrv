# websrv Cookbook

To serve files to my local cookbooks from local storage.
I needed this to work on Mac and Windows.

## Scope

TBD

## Requirements

The following environmental variables must be defined:<br>
  RepoDir = Full path directory on local system where the repos are stored<br>

### Platforms

- Redhat 7.x+
- CentOS 7.x+

### Chef

- Chef 15+

### Dependencies

- apache2
- line

## Usage

- recipe[websrv::no-ssl]

## Attributes

* default['websrv']['websrv_ip'] - The IP address of this Server

## Custom Resources

None
