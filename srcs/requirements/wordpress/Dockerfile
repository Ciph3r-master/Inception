FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y  php8.2-fpm \
                        php8.2-curl \
                        php8.2-imagick \
                        php8.2-intl \
                        php8.2-mbstring \
                        php8.2-mysql \
                        php8.2-xml \
                        php8.2-zip \
						curl \
						less \
						iputils-ping \
						mariadb-client && \
	apt-get clean

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./conf/wp_config.sh /usr/local/bin/wp_config.sh
RUN chmod +x /usr/local/bin/wp_config.sh

RUN mkdir -p /var/www/html
RUN	chown -R www-data:www-data /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_config.sh", "-F"]