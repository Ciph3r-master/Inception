FROM debian:bookworm

RUN	apt-get update && \
	apt-get install -y --no-install-recommends redis-server \
					redis-tools &&\
	apt-get clean
		
COPY ./conf/redis_config.sh /usr/local/bin/redis_config.sh

RUN chmod +x /usr/local/bin/redis_config.sh

EXPOSE 6379

ENTRYPOINT ["/usr/local/bin/redis_config.sh"]