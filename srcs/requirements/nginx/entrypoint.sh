#!/bin/bash

if [ ! -f /etc/nginx/ssl/ssl.crt ]; then
    echo "Generating ssl certificate for $DOMAIN_NAME..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/ssl.key \
		-out /etc/nginx/ssl/ssl.crt \
		-subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42/OU=42/CN=${DOMAIN_NAME}/UID=qutruche"

fi

envsubst '$DOMAIN_NAME' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

echo "NGINX server name : $DOMAIN_NAME"

nginx -g "daemon off;"