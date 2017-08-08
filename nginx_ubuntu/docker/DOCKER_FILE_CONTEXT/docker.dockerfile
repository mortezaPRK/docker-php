ARG VERSION

FROM php:$VERSION-fpm

# Extensions
# Each line represents an extensions :
# 1. Curl
# 2. GD
# 3. Mcrypt
# 4. Mysqli
# 5. ImageMagic
# 6. JSON
# 7. ZIP
# 8. XDebug
RUN apt-get update && \
    apt-get install -y libcurl3-dev && docker-php-ext-install curl && \
    apt-get install -y libpng12-dev libjpeg62-turbo-dev libfreetype6-dev && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd && \
    apt-get install -y libpq-dev && docker-php-ext-install pgsql && \
    apt-get install -y libmcrypt-dev && docker-php-ext-install mcrypt && \
    docker-php-ext-install mysqli && \
    apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick && \
    docker-php-ext-install json && \
    apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip && \
    pecl install xdebug-2.5.0 && docker-php-ext-enable xdebug && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 9000 9001

CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/01-custom.ini ; /usr/local/bin/php-fpm'
