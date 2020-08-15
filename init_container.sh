#!/bin/bash

cat >/etc/motd <<EOL
______  ___           ______________     
___   |/  /_________________  /__  /____ 
__  /|_/ /_  __ \  __ \  __  /__  /_  _ \\
_  /  / / / /_/ / /_/ / /_/ / _  / /  __/
/_/  /_/  \____/\____/\__,_/  /_/  \___/ 

A Z U R E       A P P       S E R V I C E


Moodle version : `cat /var/www/html/version.php | grep '$release' | cut -d "'" -f 2`
PHP version : `php -v | head -n 1 | cut -d ' ' -f 2`
EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# starting sshd process
sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config
/usr/sbin/sshd

# starting other services
startupCommandPath="/opt/startup/startup.sh"
$startupCommandPath
