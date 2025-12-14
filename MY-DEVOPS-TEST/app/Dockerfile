FROM alpine:3.17

# Install Nginx and PHP
RUN apk add --no-cache \
    nginx \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-opcache

# Setup Nginx directory
RUN mkdir -p /run/nginx

# Copy Configuration
COPY nginx.conf /etc/nginx/http.d/default.conf

# Copy Application Code
WORKDIR /var/www/html
COPY index.php .

# Copy Startup Script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the Cloud Run port
EXPOSE 8080

# Start command
CMD ["/start.sh"]