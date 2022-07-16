#!/bin/bash

#Pull the config file - use enviroment variables
$(printf 'aws s3 cp s3://%s/%s /var/www/html/LocalSettings.php' "$S3_CONFIG_BUCKET" "$S3_CONFIG_FILE")

#Replace the default logo file - use enviroment variables
$(printf 'aws s3 cp s3://%s/%s /var/www/html/resources/assets/wiki.png' "$S3_CONFIG_BUCKET" "$S3_LOGO_FILE")

#Get the public IP of the container and set it as the $wgServer value
IP=$(curl -S -s checkip.amazonaws.com)
echo Public IP: $IP
echo Replacing wgServer value with public ip.
sed -E -i "s/.wgServer.=.(.+);/\$wgServer = \"http\:\/\/$IP\";/" /var/www/html/LocalSettings.php

#Set folder ownership to www-data - prevents read/write permission issues
chown -R www-data /var/www/html/imagesLink
chown -R www-data /var/www/html/images

exec "$@"
