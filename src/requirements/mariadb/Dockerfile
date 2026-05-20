FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

COPY ./mariadb-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]