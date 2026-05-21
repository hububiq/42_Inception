#!/bin/bash

DATADIR="/var/lib/mysql"

if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB databse..."

    mysql_install_db --user=mysql --datadir=$DATADIR > /dev/null

    DB_ROOT_PWD=$(cat $MYSQL_ROOT_PASSWORD_FILE | tr -d '\r')
    DB_PWD=$(cat $MYSQL_PASSWORD_FILE | tr -d '\r')

    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Running innitialization script..."

    mysqld --user=mysql --bootstrap < /tmp/init.sql

    rm -f /tmp/init.sql
    echo "Database initialized!"
else
    echo "Databse already exists. Skipping initialization."
fi

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

echo "Starting MariaDB..."
exec mysqld --user=mysql --console
