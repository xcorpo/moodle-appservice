# moodle-appservice
Docker Image for Moodle on the Azure App Service

## Build
```console
docker build -t moodle-appservice .
```

## Tag
```console
docker tag moodle-appservice [YOUR REGISTRY].azurecr.io/moodle-appservice
```

## Push
```console
docker push [YOUR REGISTRY].azurecr.io/moodle-appservice
```

## Application settings
Configure these settings at the _Configuration > Application settings_ tab in the Azure Portal
- `MOODLE_DB_HOST`: Hostname for database server
- `MOODLE_DB_PASS`: Database password that Moodle will use to connect with the database
- `MOODLE_DB_USER`: Database user that Moodle will use to connect with the database
- `MOODLE_DB_PASS`: Database password that Moodle will use to connect with the database
- `MOODLE_DB_PREFIX`: Prefix that Moodle will attach to the names of tables in the database
- `MOODLE_WWWROOT`: Fixed URL that points to the site
- `MOODLE_DATAROOT`: Fixed directory for Moodle to store its data
- `MOODLE_CRONPASS`: Password to run scheduled tasks through admin/cron.php
