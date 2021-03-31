#!/bin/bash

chown -R www-data: /monitor-de-metas-api/

wget https://github.com/ufoscout/docker-compose-wait/releases/download/2.8.0/wait waitingfor

cp waitingfor /usr/local/bin

sed -i -e "s/root %%NGINX_ROOT%%;/root \/monitor-de-metas-api\/public;/g" /etc/nginx/sites-available/default.conf
sed -i -e "s/'default'\s*=>\s*'mysql'/'default' => '${DBDRIVE}'/g" app/config/database.php
sed -i  -e "s/'host'\s*=>\s*'localhost'/'host' => '${DBHOST}'/g" app/config/database.php
sed -i  -e "s/'database'\s*=>\s*'pdm_api'/'database' => '${DBNAME}'/g" app/config/database.php
sed -i  -e "s/'username'\s*=>\s*'wp'/'username' => '${DBUSER}'/g" app/config/database.php
sed -i  -e "s/'password'\s*=>\s*'wp'/'password' => '${DBPASS}'/g" app/config/database.php
sed -i  -e "s/'prefix'\s*=>\s*''/'prefix' => '${DBPREFIX}'/g" app/config/database.php

sh -c "waitingfor && php artisan migrate --env=production"

sh -c "waitingfor && php artisan db:seed"

chmod -R 777 /monitor-de-metas-api/app/storage
/etc/init.d/php5.6-fpm start

nginx