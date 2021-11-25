FROM khs1994/php:7.4.11-cli-alpine

MAINTAINER Jakub Janata <jakubjanata@gmail.com>

RUN apk add --no-cache --update yarn python2 python3 git imagemagick mysql-client openssh-client \
    autoconf \
    automake \
    bash \
    g++ \
    libc6-compat \
    libjpeg-turbo-dev \
    libpng-dev \
    make \
    pcre2-dev \
    nasm && \
    apk add --no-cache --update --virtual .build-deps $PHPIZE_DEPS imagemagick-dev && \
    pickle install imagick && \
    rm -rf /tmp/imagick && \
    apk del --no-network .build-deps

# Install composer
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');" && \
    # composer global require hirak/prestissimo && \ - waiting on support composer 2
    composer global clear-cache
