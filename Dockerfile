FROM cleveritcz/nginx:latest

ARG WORDPRESS_VERSION
ARG PHP_VERSION

RUN microdnf install -y --setopt=install_weak_deps=0 epel-release && \
    rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-9.rpm && \
    microdnf module enable php:remi-$PHP_VERSION -y && \
    microdnf install -y --setopt=install_weak_deps=0 php php-fpm php-cli php-common \ 
    php-gd php-curl php-zip php-mbstring php-mysql php-imagick unzip ; \
    mkdir /run/php-fpm && rm -f /etc/nginx/conf.d/default.conf && \
    curl -o /tmp/wordpress.zip -fsSL https://wordpress.org/wordpress-$WORDPRESS_VERSION.zip && \
    unzip /tmp/wordpress.zip -d /usr/share/nginx/html && \
    rm -f /tmp/wordpress.zip /etc/php-fpm.d/www.conf /etc/php-fpm.conf
    
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/sbin/wp
    
COPY conf/php-fpm.conf /etc/php-fpm.conf    
COPY conf/init.sh /init.sh
COPY conf/www.conf /etc/php-fpm.d/www.conf
COPY conf/wordpress.conf /etc/nginx/conf.d/wordpress.conf

WORKDIR /root

ENV PATH="~/.composer/vendor/bin:$PATH"

CMD ["/init.sh"]
