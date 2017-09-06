ARG VERSION

FROM php:$VERSION-fpm

# UNcomment to use customized source.list
# COPY sources.list /etc/apt/sources.list

# Add Extensions
RUN apt-get update && \
        # Curl
        apt-get install -y libcurl3-dev && docker-php-ext-install curl && \
        # GD
        apt-get install -y libpng12-dev libjpeg62-turbo-dev libfreetype6-dev && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd && \
        # Postgres
        apt-get install -y libpq-dev && docker-php-ext-install pgsql && \
        # Mcrypt
        apt-get install -y libmcrypt-dev && docker-php-ext-install mcrypt && \
        # Mysqli
        docker-php-ext-install mysqli && \
        # ImageMagic
        apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick && \
        # JSON
        docker-php-ext-install json && \
        # ZIP
        apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip && \
        # XDebug
        pecl install xdebug-2.5.0 && docker-php-ext-enable xdebug && \
        # Remove APT lists
        rm -rf /var/lib/apt/lists/* && \
        # Add remote host fo xdebug
        echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/20-xdebug.ini && \
        # Composer
        EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig) && \
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
            ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
            if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php exit 1; fi && \
            php composer-setup.php --quiet && \
            rm composer-setup.php && \
            mv composer.phar /usr/local/bin/composer

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD exec /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/20-xdebug.ini && exec /usr/local/sbin/php-fpm'
