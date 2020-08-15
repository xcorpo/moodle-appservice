#!/bin/bash

while true; do
        sudo -u www-data /usr/bin/curl http://localhost/admin/cron.php?password=`echo $MOODLE_CRON_PASS`
        sudo -u www-data sleep 60
done
