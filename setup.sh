#!/bin/bash

#!/bin/bash


cat << EOF > /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = https://rpm.mariadb.org/10.6/centos9-aarch64/$releasever/$basearch
gpgkey= https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum install -y httpd MariaDB-server php php-mysqlnd php-fpm wget

# Start and enable services
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb

# Secure MariaDB (optional, but recommended for production)
# mysql_secure_installation (interactive, so not ideal for user data)

# Create WordPress database and user
mysql -u root -e "CREATE DATABASE wordpress_db;"
mysql -u root -e "CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'your_strong_password';"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Download and install WordPress
wget https://wordpress.org/latest.tar.gz -P /tmp/
tar -xzf /tmp/latest.tar.gz -C /var/www/html/
mv /var/www/html/wordpress/* /var/www/html/
rm -rf /var/www/html/wordpress
rm /tmp/latest.tar.gz

# Configure wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i 's/database_name_here/wordpress_db/g' /var/www/html/wp-config.php
sed -i 's/username_here/wordpress_user/g' /var/www/html/wp-config.php
sed -i 's/password_here/your_strong_password/g' /var/www/html/wp-config.php

# Set appropriate permissions
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/