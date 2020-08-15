#!/bin/bash

cd /home/site/

# create session data symbolic link
mkdir moodledata
rm -rf moodledata/sessions
ln -s /var/www/moodledata/sessions/ moodledata/sessions

# fix permissions
chown -R www-data:www-data moodledata/
chmod -R 0777 moodledata/

# starting cron_job.sh in the background
"/opt/startup/cron_job.sh" </dev/null &>/dev/null &

# start apache server
export APACHE_PORT=8080
apache2-foreground
