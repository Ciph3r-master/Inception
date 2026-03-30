#!/bin/bash

set -e

#Retirer la boucle infinie
while ! mariadb-admin ping -h"mariadb" --silent; do
    echo "Waiting MariaDB..."
    sleep 2
done

if [ ! -f "wp-config.php" ]; then

    echo "WordPress installation in progress..."

    wp core download --allow-root

    wp config create --allow-root \
        --dbname=wordpress_db \
        --dbuser=wp_user \
        --dbpass=password \
        --dbhost=mariadb

    wp core install --allow-root \
        --url=localhost \
        --title="Big website" \
        --admin_user="admin" \
        --admin_password="admin" \
        --admin_email="admin@test.fr"

    wp user create --allow-root \
        "bernard" "user@test.fr" \
        --role=author \
        --user_pass="password"

	wp theme install prespa-saas --activate --allow-root 

    echo "WordPress is ready !"
else
    echo "WordPress is already installed."
fi

exec /usr/sbin/php-fpm8.2 -F