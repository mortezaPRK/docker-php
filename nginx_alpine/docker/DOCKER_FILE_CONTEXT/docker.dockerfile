ARG VERSION

FROM php:$VERSION-fpm-alpine

# Add Extensions
RUN apk upgrade --update && \
    # Curl :
    apk add curl-dev && \
    docker-php-ext-install curl && \
    # GD :
    apk add libjpeg-turbo-dev libpng-dev freetype-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd && \
    # Postgres :
    apk add postgresql-dev && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql && \
    # Mcrypt :
    apk add libmcrypt-dev && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt && \
    # iconv :
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) iconv && \
    # Mysqli :
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli && \
    # ImageMagic :
    apk add imagemagick-dev libtool libc-dev autoconf gcc make pcre-dev && \
    yes "" | pecl install imagick && \
    docker-php-ext-enable imagick && \
    # JSON :
    docker-php-ext-install json && \
    # ZIP :
    docker-php-ext-configure zip --with-zlib-dir=/usr && \
    docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip && \
    # XDebug :
    apk add autoconf libc-dev gcc make && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    # Remove apk lists
    apk -v cache clean && \
    # Add remote host fo xdebug
    echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; /usr/local/sbin/php-fpm'
