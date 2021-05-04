#!/bin/bash
echo "Nom user?"
read user
passwd $user
mkdir /home/hosting/$user
mkdir /home/hosting/$user/arxius

useradd -g sftpserver -s /bin/bash -d /home/hosting/$user $user

chown $user:sftpserver /home/hosting/$user/arxius

chown root:root /home/hosting
chown root:root /home/hosting/$user

chmod 755 /home/hosting/$user/arxius
chmod 755 /home/hosting/$user
chmod 755 /home/hosting


echo "Match user $user
ChrootDirectory /home/hosting/$user
ForceCommand internal-sftp" >> /etc/ssh/sshd_config

service ssh restart

#VIRTUAL HOST
cd /etc/apache2/sites-available
touch $user.conf
echo "<VirtualHost *:80>

        ServerAdmin administrador@alojthunberg.asix2.iesmontsia.cat
        ServerName $user.alojthunberg.asix2.iesmontsia.cat
        ServerAlias $user.alojthunberg.asix2.iesmontsia.cat

        DocumentRoot /home/hosting/$user/arxius

        <Directory /home/hosting/$user/arxius>
             AllowOverride All
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/example.com.error.log
        CustomLog ${APACHE_LOG_DIR}/example.com.access.log combined

#RewriteEngine on
#RewriteCond %{SERVER_NAME} =alojthunberg.asix2.iesmontsia.cat [OR]
#RewriteCond %{SERVER_NAME} =www.alojthunberg.asix2.iesmontsia.cat
</VirtualHost>" > /etc/apache2/sites-available/$user.conf

cd /etc/apache2/sites-available
a2ensite $user.conf
service apache2 reload
