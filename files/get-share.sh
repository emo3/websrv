if [[ -n "$1" ]]; then
  echo "Part A of script"
  VBoxManage list --long vms|grep UUID
  echo "*** set uuid with above value"
  echo "example: export uuid=9df71aeb-7a01-1234-98c8-04cc0273238c"
  vagrant global-status|grep $1
  echo "*** set id with above value"
  echo "example: export id=1c65e19"
  echo "run: ~/chef/scripts/set-share.sh"
else
  echo "Usage: $0 {name of websrv}"
fi
