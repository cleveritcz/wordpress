FROM cleveritcz/nginx:latest

ARG WORDPRESS_VERSION
ARG PHP_VERSION

RUN microdnf install -y --setopt=install_weak_deps=0 epel-release && \
    rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-9.rpm && \
    microdnf module enable php:remi-$PHP_VERSION -y && \
    microdnf install -y --setopt=install_weak_deps=0 php php-fpm php-cli php-common \ 
    php-gd php-curl php-zip php-mbstring php-mysql php-imagick unzip ; \
    microdnf install -y --setopt=install_weak_deps=0 supervisor && mkdir /run/php-fpm && \
    rm -f /etc/nginx/conf.d/default.conf && \
    curl -o /tmp/wordpress.zip -fsSL https://wordpress.org/wordpress-$WORDPRESS_VERSION.zip && \
    unzip /tmp/wordpress.zip -d /usr/share/nginx/html && \
    rm -f /tmp/wordpress.zip /etc/php-fpm.d/www.conf
    
RUN curl -o composer-installer.php -fsSL https://getcomposer.org/installer && \
    php composer-installer.php --filename=composer --install-dir=/usr/local/bin && \
    rm -f composer-installer.php && composer global require wp-cli/wp-cli-bundle
    
COPY conf/www.conf /etc/php-fpm.d/www.conf
COPY conf/php-supervisord.ini /etc/supervisord.d/php-supervisord.ini
COPY conf/wordpress.conf /etc/nginx/conf.d/wordpress.conf

ENV PATH="~/.composer/vendor/bin:$PATH"

CMD ["/usr/bin/supervisord", "-n"]
