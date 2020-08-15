#!/bin/bash

sed -i '/check if execution allowed/ a if (!($_SERVER['\''REMOTE_ADDR'\''] == '\''127.0.0.1'\'')) {\
    // This script cannot be accessed remotely.\
    print("!!! IP not allowed. !!!");\
    exit;\
}\
' /var/www/html/admin/cron.php
