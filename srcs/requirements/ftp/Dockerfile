FROM debian:bookworm

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends vsftpd curl && \
	apt-get clean


COPY ./conf/vsftpd_config.sh /usr/local/bin/vsftpd_config.sh
RUN chmod +x /usr/local/bin/vsftpd_config.sh


EXPOSE 21 40000-40005

ENTRYPOINT ["/usr/local/bin/vsftpd_config.sh"]