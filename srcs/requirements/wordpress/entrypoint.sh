#!/bin/bash

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "WordPress not found. Downloading and installing..."

    wp core download --allow-root

    DB_PWD=$(cat /run/secrets/db_password | tr -d '\r')
    WP_ADMIN_PWD=$(cat /run/secrets/wp_admin_password | tr -d '\r')
    WP_USER_PWD=$(cat /run/secrets/wp_user_password | tr -d '\r')

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PWD" \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PWD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PWD" \
        --allow-root
    
      echo "WordPress successfully installed and configured!"
else
    echo "WordPress is already installed. Skipping setup."
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F