FROM php:8.2-fpm
RUN apt-get update && apt-get install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /var/www/html/index.php
CMD service nginx start && php-fpm

