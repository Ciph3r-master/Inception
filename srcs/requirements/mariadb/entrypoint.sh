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

DB_PASSWORD=$(get_secret "mariadb_wp_user_password")

cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${MARIADB_WORDPRESS_DB}\`;
CREATE USER IF NOT EXISTS '${MARIADB_WP_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_WORDPRESS_DB}\`.* TO '${MARIADB_WP_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "MariaDB setup completed successfully."

exec mysqld --init-file=/tmp/init.sql