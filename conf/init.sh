#!/bin/bash

# Function to handle shutdowns gracefully
shutdown() {
    # Stop PHP-FPM
    /usr/sbin/php-fpm -F --force-quit

    # Stop Nginx
    /usr/sbin/nginx -s quit
    exit 0
}

# Start PHP-FPM
/usr/sbin/php-fpm -F

# Start Nginx
/usr/sbin/nginx -g "daemon off;"

# Register the shutdown function
trap "shutdown" SIGINT SIGTERM

# Keep the container running
while true; do
  sleep 60
done
