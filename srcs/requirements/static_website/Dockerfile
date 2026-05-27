FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y busybox curl && \
    apt-get clean


WORKDIR /var/www/html

COPY ./website /var/www/html

RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 8000

CMD [ "busybox", "httpd", "-f", "-p", "8000", "-h", "/var/www/html" ]