#!/bin/sh
dnf install -y httpd php php-mysqli mariadb105
dnf install -y git

case $(ps -p 1 -o comm | tail -1) in 
systemd) systemctl enable --now httpd ;;
init) chkconfig httpd on; service httpd start ;;
*) echo "Error starting httpd (OS not using init or systemd)." 2>&1
esac

if [ ! -f /var/www/html/bootcamp-app.tar.gz ]; then
cd /var/www/html
# wget https://s3.amazonaws.com/immersionday-labs/bootcamp-app.tar
# tar xvf bootcamp-app.tar
git clone https://github.com/steveauztin/aws-ignite-2023.git
cd aws-ignite-2023
mv rds/app/* ../
cd ..
rm -fr aws-ignite-2023
chown apache:root /var/www/html/rds.conf.php
fi
dnf update -y