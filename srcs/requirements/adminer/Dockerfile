FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y curl php-cli php-mysql && \
    apt-get clean


WORKDIR /var/www/html

RUN curl -L -o index.php https://www.adminer.org/latest.php

RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 8080

CMD [ "php", "-S", "0.0.0.0:8080", "/var/www/html/index.php" ]