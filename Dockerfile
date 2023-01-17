FROM cleveritcz/nginx:latest

ARG WORDPRESS_VERSION

RUN microdnf install -y --setopt=install_weak_deps=0 php7.4-fpm php7.4 unzip epel-release && \
    microdnf install -y --setopt=install_weak_deps=0 supervisor && mkdir /run/php-fpm && \
    rm -f /etc/nginx/conf.d/default.conf && \
    curl -o /tmp/wordpress.zip -fsSL https://wordpress.org/wordpress-$WORDPRESS_VERSION.zip && \
    unzip /tmp/wordpress.zip -d /usr/share/nginx/html
    
COPY conf/php-supervisord.ini /etc/supervisord.d/php-supervisord.ini
COPY conf/wordpress.conf /etc/nginx/conf.d/wordpress.conf

CMD ["/usr/bin/supervisord", "-n"]
