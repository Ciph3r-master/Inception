FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y  nginx   \
                        openssl \
                        curl && \
	apt-get clean

EXPOSE 443

COPY ./conf/nginx.conf /etc/nginx/conf.d/nginx.conf

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ssl.key \
    -out /etc/nginx/ssl/ssl.crt \
    -subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/O=42/OU=42/CN=qutruche.42.fr/UID=qutruche"

CMD [ "nginx", "-g", "daemon off;" ]