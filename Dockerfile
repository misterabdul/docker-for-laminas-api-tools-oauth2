FROM rockylinux:8.5

LABEL author="Abdul Pasaribu" \
    author.email="abdoelrachmad@gmail.com" \
    author.website="https://misterabdul.github.io"
LABEL name="Docker for laminas template" \
    description="Docker image for laminas template usage" \
    url="https://hub.docker.com/r/misterabdul/docker-for-laminas-template"
LABEL image.os="RockyLinux-8.5" \
    image.server="nginx-1.20" \
    image.php="php-8.0"

RUN dnf update -y
RUN dnf install -y epel-release
RUN dnf install -y curl \
    git \
    htop \
    openssh \
    rsync \
    supervisor \
    unzip \
    vim \
    wget \
    zip

RUN dnf module reset -y nginx \
    && dnf module enable -y nginx:1.20 \
    && dnf install -y nginx \
    nginx-all-modules

RUN dnf module reset -y php \
    && dnf module enable -y php:8.0 \
    && dnf install -y php \
    php-bcmath \
    php-cli \
    php-common \
    php-curl \
    php-fpm \
    php-gd \
    php-gmp \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mysqlnd \
    php-odbc \
    php-opcache \
    php-pdo \
    php-pear* \
    php-pecl* \
    php-pgsql \
    php-process \
    php-snmp \
    php-xml \
    php-xmpphp \
    php-zip

RUN wget "https://getcomposer.org/installer" -O composer-installer.php \
    && php composer-installer.php --filename=composer --install-dir=/usr/local/bin \
    && rm -f composer-installer.php

RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf \
    && sed -i -e "s/;\?error_log.*\$/error_log = \/dev\/stderr/g" /etc/php-fpm.conf \
    && sed -i -e "s/;\?slowlog.*\$/slowlog = \/dev\/stdout/g" /etc/php-fpm.d/www.conf \
    && sed -i -e "s/;\?user\s*=.*\$/user = root/g" /etc/php-fpm.d/www.conf \
    && sed -i -e "s/;\?group\s*=.*\$/group = root/g" /etc/php-fpm.d/www.conf \
    && sed -i -e "s/;\?php_admin_value\[error_log\].*\$/php_admin_value[error_log] = \/dev\/stderr/g" /etc/php-fpm.d/www.conf \
    && mkdir -p /run/php-fpm \
    && rm /etc/nginx/default.d/php.conf \
    && mkdir -p /var/www/dev/web-front-end/current \
    && mkdir -p /var/www/dev/api/current
COPY ./etc/nginx/ /etc/nginx/
COPY ./etc/supervisord.conf /etc/supervisord.conf
COPY ./etc/supervisord.d/ /etc/supervisord.d/
COPY ./var/www/dev/ /var/www/dev/

WORKDIR /var/www/dev/api/current
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
