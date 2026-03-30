FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y mariadb-server \
	mariadb-client && \
	apt-get clean

RUN	mkdir -p /var/lib/mysql
RUN	chown -R mysql:mysql /var/lib/mysql

RUN mkdir -p /run/mysqld \
    && chown mysql:mysql /run/mysqld

COPY --chown=mysql:mysql ./sql/init.sql /etc/mysql/init.sql
COPY --chown=mysql:mysql ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

USER mysql

CMD ["mysqld", "--init-file=/etc/mysql/init.sql"]