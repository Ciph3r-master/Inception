#!/bin/bash

set -e

get_secret()
{
    local secret_name=$1
    local path="/run/secrets/$secret_name"
    if [ -f "$path" ]; then
        cat "$path"
    else
        echo "Error: Secret '$secret_name' not found at '$path'" >&2
        exit 1
    fi 
}

if [ ! -f "wp-config.php" ]; then

    echo "WordPress installation in progress..."

    wp core download --allow-root

    DB_PASSWORD=$(get_secret "mariadb_wp_user_password")


    wp config create --allow-root \
        --dbname="${MARIADB_WORDPRESS_DB}" \
        --dbuser="${MARIADB_WP_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=mariadb

    ADMIN_NAME=$(get_secret "wp_admin_name")
    ADMIN_PASSWORD=$(get_secret "wp_admin_password")
    ADMIN_MAIL=$(get_secret "wp_admin_mail")

    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${ADMIN_NAME}" \
        --admin_password="${ADMIN_PASSWORD}" \
        --admin_email="${ADMIN_MAIL}"

    USER_NAME=$(get_secret "wp_user_name")
    USER_PASSWORD=$(get_secret "wp_user_password")
    USER_MAIL=$(get_secret "wp_user_mail")

    wp user create --allow-root \
        "${USER_NAME}" "${USER_MAIL}" \
        --role=author \
        --user_pass="${USER_PASSWORD}"

	wp theme install "${WORDPRESS_THEME}" --activate --allow-root 

    echo "WordPress is ready !"
else
    echo "WordPress is already installed."
fi

exec /usr/sbin/php-fpm8.2 -F