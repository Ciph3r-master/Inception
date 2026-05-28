FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
						wget \
						ca-certificates \
    && apt-get clean

EXPOSE 8080

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN wget https://github.com/google/cadvisor/releases/download/v0.57.0/cadvisor-v0.57.0-linux-amd64 -O /usr/local/bin/cadvisor
RUN chmod +x /usr/local/bin/cadvisor

ENTRYPOINT ["/entrypoint.sh"]