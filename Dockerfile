FROM php:7.3

MAINTAINER Jakub Janata <jakubjanata@gmail.com>

RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    mkdir -p /usr/share/man/man7 && \
    apt-get install -y unzip wget mysql-client postgresql-client git gnupg zlib1g libpng-dev libzip-dev libpq-dev libmagickwand-dev

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
    apt-get install nodejs -y && \
    command -v node && \
    command -v npm

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install yarn

# Install Mysql + Postgre PDO + extensions
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql && \
    docker-php-ext-install zip gd exif mbstring bcmath

# Install APCu + imagick
RUN pecl install apcu imagick redis && \
    echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini && \
    echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

# Memory Limit
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# Install composer
RUN wget https://getcomposer.org/composer.phar -q && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    composer --version && \
    composer global require hirak/prestissimo
