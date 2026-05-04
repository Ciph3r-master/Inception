FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y  nginx   \
                        openssl \
                        gettext-base \
                        curl && \
	apt-get clean

EXPOSE 443

COPY ./conf/nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

RUN mkdir -p /etc/nginx/ssl

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]