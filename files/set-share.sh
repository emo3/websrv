if [[ -n "$id" ]]; then
  if [[ -n "$uuid" ]]; then
    vagrant halt ${id}
    VBoxManage sharedfolder add ${uuid} --name html --hostpath ~/repos
    vagrant up ${id}
  else
    echo "Usage: Must have uuid set"
    echo "Please see get-share.sh"
  fi
else
  echo "Usage: Must have id set"
  echo "Please see get-share.sh"
fi
