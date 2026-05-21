FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# openssl is baked into the image and starts immediately with the container, therefore i dont have .sh 
# domain name hardcoded because docker cant see my .env on build time. container doesnt exist yet
# run time its only after docker compose up. here the image turns into container
# so: configs are for build time, .sh scripts for run time!
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \  
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=PL/ST=Warsaw/L=Warsaw/O=42/OU=42/CN=hgatarek.42.fr/UID=hgatarek"

COPY ./nginx.conf /etc/nginx/sites-available/default

EXPOSE 443

# same like exec for mariadb and wordpress to keep pid 1 alive. -g is for global foreground,
# otherwise nginx instantly goes to background 
CMD ["nginx", "-g", "daemon off;"]
