echo "Syncing 7-os"
rsync -avzh rsync://mirror.umd.edu/centos/7/os/x86_64/      --exclude=debug --exclude=drpms --delete /var/www/html/centos7/os
echo "Syncing 7-updates"
rsync -avzh rsync://mirror.umd.edu/centos/7/updates/x86_64/ --exclude=debug --exclude=drpms --delete /var/www/html/centos7/updates
echo "Syncing 7-extras"
rsync -avzh rsync://mirror.umd.edu/centos/7/extras/x86_64/  --exclude=debug --exclude=drpms --delete /var/www/html/centos7/extras
echo "Syncing 7-epel"
rsync -avzh rsync://mirror.umd.edu/fedora/epel/7/x86_64/    --exclude=debug --exclude=drpms --delete /var/www/html/epel7
echo "Syncing 7-rhel"
reposync --gpgcheck --plugins --repoid=rhel-7-server-rpms --repoid=rhel-7-server-extras-rpms --download_path=/var/www/html --downloadcomps --download-metadata --delete --newest-only
for x in rhel-7-server-rpms rhel-7-server-extras-rpms; do
  cd /var/www/html/$x
  createrepo -v /var/www/html/$x/ -g comps.xml
  gunzip *updateinfo.xml.gz
  mv *updateinfo.xml ./repodata/updateinfo.xml
  modifyrepo /var/www/html/$x/repodata/updateinfo.xml /var/www/html/$x/repodata
done
chown -R apache:apache /var/www/html
yum -y update
