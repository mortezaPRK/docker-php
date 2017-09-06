ARG VERSION

FROM php:$VERSION-fpm-alpine

# Add Extensions
RUN apk upgrade --update && \
        echo "Curl :" && \
        apk add --no-cache curl-dev && \
        docker-php-ext-install curl && \
        echo "GD :" && \
        apk add --no-cache libjpeg-turbo-dev libpng-dev freetype-dev && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd && \
        echo "Postgres :" && \
        apk add --no-cache postgresql-dev && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql && \
        echo "Mcrypt :" && \
        apk add --no-cache libmcrypt-dev && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt && \
        echo "iconv :" && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) iconv && \
        echo "Mysqli :" && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli && \
        echo "ImageMagic :" && \
        apk add --no-cache imagemagick-dev libtool libc-dev autoconf gcc make pcre-dev && \
        yes "" | pecl install imagick && \
        docker-php-ext-enable imagick && \
        echo "JSON :" && \
        docker-php-ext-install json && \
        echo "ZIP :" && \
        docker-php-ext-configure zip --with-zlib-dir=/usr && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip && \
        echo "XDebug :" && \
        apk add --no-cache autoconf libc-dev gcc make && \
        pecl install xdebug && \
        docker-php-ext-enable xdebug && \
    echo "Add remote host fo xdebug" && \
        echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig) && \
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
        if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php exit 1; fi && \
        php composer-setup.php --quiet && \
        rm composer-setup.php && \
        mv composer.phar /usr/local/bin/composer

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; /usr/local/sbin/php-fpm'
