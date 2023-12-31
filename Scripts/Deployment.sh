#! /bin/bash 
echo "############################################################"
echo "GLPI Web bootstrap script starting..."
echo "############################################################"
echo "."

#disable history subsitution
set +H
cd /root/
#Install Apache git php
echo "Installing pre-reqs"
apt update
apt install ufw mysql-client git apache2 Php8.1 php8.1-xml php8.1-common php8.1-curl php8.1-gd php8.1-intl php8.1-mysqli php8.1-bz2 php8.1-phar php8.1-zip php8.1-exif php8.1-ldap Php8.1-opcache -y
#setup firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
#download glpi
wget -O glpi.tgz https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
#extract glpi
tar -xzf glpi.tgz -C /var/www/ 
#delete tar
rm glpi.tgz
#check /mnt/data/files
if [ -d "/mnt/data/files" ]
then
    #Delete files dir
    rm -rf /var/www/glpi/files
else
    #move file dir
    mv /var/www/glpi/files /mnt/data/
fi
#symlink to volume
ln -s /mnt/data/files /var/www/glpi
#Check /mnt/data/plugins
if [ -d "/mnt/data/plugins" ]
then
    #do Nothing
    echo "plugins dir exists on shared"
else
    #create plugins dir on shared
    mkdir /mnt/data/plugins
fi
#bind the dir to the dir. you CANNOT use a symlink
mount --bind /mnt/data/plugins /var/www/glpi/plugins
#persist mounting
echo "/mnt/data/plugins /var/www/glpi/plugins none defaults,bind 0 0" >> /etc/fstab
#configure Apache
echo "Configuring apache"
#Enable Rewrite
a2enmod rewrite
#configure site
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/glpi.conf
echo "    ServerName ${host}.${domain}.${tld}" >> /etc/apache2/sites-available/glpi.conf
echo "    DocumentRoot /var/www/glpi/public" >> /etc/apache2/sites-available/glpi.conf
echo "    <Directory /var/www/glpi/public>" >> /etc/apache2/sites-available/glpi.conf
echo "        Require all granted" >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteEngine On" >> /etc/apache2/sites-available/glpi.conf
echo "        # Redirect all requests to GLPI router, unless file exists." >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteCond %%{REQUEST_FILENAME} !-f" >> /etc/apache2/sites-available/glpi.conf
echo "        RewriteRule ^(.*)$ index.php [QSA,L]" >> /etc/apache2/sites-available/glpi.conf
echo "    </Directory>" >> /etc/apache2/sites-available/glpi.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/glpi.conf
#symlink site file
ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled
#clone db schema
git clone https://github.com/The-NOG/GLPI-Base-SQL.git
#inflate db
mysql --host=${db_host} --port=${db_port} --user=${db_user} -p${db_password} ${db_schema} < /root/GLPI-Base-SQL/base.sql
#write config
echo "<?php" >> /var/www/glpi/config/config_db.php
echo "class DB extends DBmysql {" >> /var/www/glpi/config/config_db.php
echo "   public \$dbhost = '${db_host}:${db_port}';" >> /var/www/glpi/config/config_db.php
echo "   public \$dbuser = '${db_user}';" >> /var/www/glpi/config/config_db.php
echo "   public \$dbpassword = '${db_password}';" >> /var/www/glpi/config/config_db.php
echo "   public \$dbdefault = '${db_schema}';" >> /var/www/glpi/config/config_db.php
echo "   public \$use_utf8mb4 = true;" >> /var/www/glpi/config/config_db.php
echo "   public \$allow_myisam = false;" >> /var/www/glpi/config/config_db.php
echo "   public \$allow_datetime = false;" >> /var/www/glpi/config/config_db.php
echo "   public \$allow_signed_keys = false;" >> /var/www/glpi/config/config_db.php
echo "   public \$use_timezones = true;" >> /var/www/glpi/config/config_db.php
echo "}" >> /var/www/glpi/config/config_db.php
#own the webroot
chown www-data:www-data /var/www/glpi -R
chown www-data:www-data /mnt/data/files -R
chown www-data:www-data /mnt/data/plugins -R
#delete install.php
rm /var/www/glpi/install/install.php
#restart apache
systemctl restart apache2

echo "#######################################################"
echo "GLPI Web bootstrap script done."
echo "#######################################################"