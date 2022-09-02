FROM ubuntu:22.04

LABEL author="Abdul Pasaribu" \
    author.email="abdoelrachmad@gmail.com" \
    author.website="https://misterabdul.github.io"
LABEL name="Docker for Laminas API Tools OAuth2" \
    description="Docker image for Laminas API Tools OAuth2 apps." \
    url="https://hub.docker.com/r/misterabdul/docker-for-laminas-api-tools-oauth2"
LABEL image.os="Ubuntu-22.04" \
    image.server="nginx-1.22" \
    image.php="php-7.4"

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get update -y \
    && apt-get upgrade -y
RUN apt-get install -y software-properties-common \
    curl \
    git \
    htop \
    openssh-client \
    rsync \
    supervisor \
    unzip \
    vim \
    wget \
    zip

RUN add-apt-repository -y ppa:ondrej/nginx \
    && apt-get update -y \
    && apt-get install -y nginx-full=1.22.* \
    && apt-mark hold nginx-full=1.22.*

RUN add-apt-repository -y ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y php7.4 \
    php7.4-common \
    php7.4-bcmath \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-fpm \
    php7.4-gd \
    php7.4-gmp \
    php7.4-intl \
    php-json \
    php7.4-ldap \
    php7.4-mbstring \
    php7.4-mysqlnd \
    php7.4-odbc \
    php7.4-opcache \
    php7.4-pdo \
    php-pear* \
    php-pecl* \
    php7.4-pgsql \
    php7.4-snmp \
    php7.4-xml \
    php7.4-zip

RUN update-alternatives --set php /usr/bin/php7.4 \
    && update-alternatives --set phar /usr/bin/phar7.4 \
    && ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

RUN wget "https://getcomposer.org/installer" -O composer-installer.php \
    && php composer-installer.php --filename=composer --install-dir=/usr/local/bin \
    && rm -f composer-installer.php

RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i -e "s/;\?error_log.*\$/error_log = \/dev\/stderr/g" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i -e "s/;\?pid\s*=.*\$/pid = \/var\/run\/php-fpm\/php-fpm.pid/g" /etc/php/7.4/fpm/php-fpm.conf \
    && sed -i -e "s/;\?slowlog.*\$/slowlog = \/dev\/stdout/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i -e "s/;\?user\s*=.*\$/user = root/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i -e "s/;\?group\s*=.*\$/group = root/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i -e "s/;\?php_admin_value\[error_log\].*\$/php_admin_value[error_log] = \/dev\/stderr/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i -e "s/;\?listen\s*=.*\$/listen = \/var\/run\/php-fpm\/www.sock/g" /etc/php/7.4/fpm/pool.d/www.conf \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/www/dev/web-front-end/current \
    && mkdir -p /var/www/dev/api/current
RUN mkdir -p /run/supervisor
COPY ./etc/nginx/ /etc/nginx/
COPY ./etc/supervisord.conf /etc/supervisord.conf
COPY ./etc/supervisord.d/ /etc/supervisord.d/
COPY ./var/www/dev/ /var/www/dev/

WORKDIR /var/www/dev/api/current
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
