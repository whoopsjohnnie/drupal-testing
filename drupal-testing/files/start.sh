#!/bin/bash

export BASEHTML="/var/www/html"
export DOCROOT="/var/www/html/web"
export GRPID=$(stat -c "%g" /var/lib/mysql/)
export DRUSH="/.composer/vendor/drush/drush/drush"
export LOCAL_IP=$(hostname -I| awk '{print $1}')
export HOSTIP=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "${HOSTIP} dockerhost" >> /etc/hosts
echo "Started Container: $(date)"

# Start supervisord
supervisord -c /etc/supervisor/conf.d/supervisord.conf -l /tmp/supervisord.log

# # If there is no index.php, download drupal
# if [ ! -f ${DOCROOT}/index.php ]; then
#   echo "**** No Drupal found. Downloading latest to ${DOCROOT}/ ****"
#   cd ${BASEHTML};
#   ${DRUSH} -vy dl drupal \
#            --default-major=8 --drupal-project-rename="web"
#   chmod a+w ${DOCROOT}/sites/default;
#   mkdir ${DOCROOT}/sites/default/files;
#   wget "http://www.adminer.org/latest.php" -O ${DOCROOT}/adminer.php
#   chown -R www-data:${GRPID} ${DOCROOT}
#   chmod -R ug+w ${DOCROOT}
# else
#   echo "**** ${DOCROOT}/index.php found  ****"
# fi

# Change root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Clear caches and reset files perms
chown -R www-data:${GRPID} ${DOCROOT}/sites/default/
chmod -R ug+w ${DOCROOT}/sites/default/
chown -R mysql:${GRPID} /var/lib/mysql/
chmod -R ug+w /var/lib/mysql/
find -type d -exec chmod +xr {} \;
(sleep 3; drush --root=${DOCROOT}/ cache-rebuild 2>/dev/null) &

echo
echo "---------------------- USERS CREDENTIALS ($(date +%T)) -------------------------------"
echo
echo "    DRUPAL:  http://${LOCAL_IP}              with user/pass: admin/admin"
echo
echo "    MYSQL :  http://${LOCAL_IP}/adminer.php  drupal/${DRUPAL_PASSWORD} or root/${ROOT_PASSWORD}"
echo "    SSH   :  ssh root@${LOCAL_IP}            with user/pass: root/${ROOT_PASSWORD}"
echo
echo "  Please report any issues to https://github.com/ricardoamaro/drupal8-docker-app"
echo "  USE CTRL+C TO STOP THIS APP"
echo
echo "------------------------------ STARTING SERVICES ---------------------------------------"

tail -f /tmp/supervisord.log
