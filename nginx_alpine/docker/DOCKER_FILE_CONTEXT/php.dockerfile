ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

COPY usermod /usermod
# NOTICE: install all package with one apk command to avoide downloading and installing dependencies. Use one RUN directive to reduce image size. remove comments inside RUN
RUN apk upgrade --update && \
        # Curl
        apk add --no-cache curl-dev && \
        docker-php-ext-install curl && \
        # GD
        apk add --no-cache libjpeg-turbo-dev libpng-dev freetype-dev && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd && \
        # Postgres
        apk add --no-cache postgresql-dev && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql && \
        # Mcrypt
        apk add --no-cache libmcrypt-dev && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt && \
        # iconv
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) iconv && \
        # Mysqli
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli && \
        # ImageMagic
        apk add --no-cache imagemagick-dev libtool libc-dev autoconf gcc make pcre-dev && \
        yes "" | pecl install imagick && \
        docker-php-ext-enable imagick && \
        # JSON
        docker-php-ext-install json && \
        # ZIP
        docker-php-ext-configure zip --with-zlib-dir=/usr && \
        docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip && \
        # XDebug
        apk add --no-cache autoconf libc-dev gcc make && \
        pecl install xdebug && \
        docker-php-ext-enable xdebug && \
        # Add remote host fo xdebug
        echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
        # Composer
        EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig) && \
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
            ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
            if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php exit 1; fi && \
            php composer-setup.php --quiet && \
            rm composer-setup.php && \
            mv composer.phar /usr/local/bin/composer && \
        # change uid and gid of php-fpm proccess
        chmod +x /usermod && sleep 1 && sync && \
            /usermod xfs xfs 32 32 33 33 && \
            /usermod www-data www-data 33 33 82 82 && \
        rm /usermod

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD exec /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && exec /usr/local/sbin/php-fpm'
