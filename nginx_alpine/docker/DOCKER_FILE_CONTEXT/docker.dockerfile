ARG VERSION

FROM php:$VERSION-fpm-alpine

# Add Extensions
RUN apk upgrade --update && \
    echo "Curl :" && \
    apk add curl-dev && \
    docker-php-ext-install curl && \
    echo "GD :" && \
    apk add libjpeg-turbo-dev libpng-dev freetype-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd && \
    echo "Postgres :" && \
    apk add postgresql-dev && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql && \
    echo "Mcrypt :" && \
    apk add libmcrypt-dev && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt && \
    echo "iconv :" && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) iconv && \
    echo "Mysqli :" && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli && \
    echo "ImageMagic :" && \
    apk add imagemagick-dev libtool libc-dev autoconf gcc make pcre-dev && \
    yes "" | pecl install imagick && \
    docker-php-ext-enable imagick && \
    echo "JSON :" && \
    docker-php-ext-install json && \
    echo "ZIP :" && \
    docker-php-ext-configure zip --with-zlib-dir=/usr && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip && \
    echo "XDebug :" && \
    apk add autoconf libc-dev gcc make && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "Add remote host fo xdebug" && \
    echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; /usr/local/sbin/php-fpm'
