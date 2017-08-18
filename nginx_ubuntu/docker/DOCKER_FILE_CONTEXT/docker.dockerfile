ARG VERSION

FROM php:$VERSION-fpm

# UNcomment to use customized source.list
# COPY sources.list /etc/apt/sources.list

# Add Extensions
RUN apt-get update && \
    # Curl :
    apt-get install -y libcurl3-dev && docker-php-ext-install curl && \
    # GD :
    apt-get install -y libpng12-dev libjpeg62-turbo-dev libfreetype6-dev && docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd && \
    # Postgres :
    apt-get install -y libpq-dev && docker-php-ext-install pgsql && \
    # Mcrypt :
    apt-get install -y libmcrypt-dev && docker-php-ext-install mcrypt && \
    # Mysqli :
    docker-php-ext-install mysqli && \
    # ImageMagic :
    apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagick && docker-php-ext-enable imagick && \
    # JSON :
    docker-php-ext-install json && \
    # ZIP :
    apt-get install -y zlib1g-dev && docker-php-ext-configure zip --with-zlib-dir=/usr && docker-php-ext-install zip && \
    # XDebug :
    pecl install xdebug-2.5.0 && docker-php-ext-enable xdebug && \
    # Remove APT lists
    rm -rf /var/lib/apt/lists/* && \
    # Add remote host fo xdebug
    echo "xdebug.remote_host=" >> /usr/local/etc/php/conf.d/20-xdebug.ini

# Expose NGINX and XDEBUG
EXPOSE 9000 9001

CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /usr/local/etc/php/conf.d/20-xdebug.ini ; /usr/local/sbin/php-fpm'
