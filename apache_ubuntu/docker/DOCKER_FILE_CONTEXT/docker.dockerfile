FROM ubuntu:16.04


# Argument from docker-compose.yml to determine php version (7.0 or 7.1) and hostname. don't touch these :)
ARG VERSION
ARG HOSTNAME

# Uncomment to use custom apt mirror
# COPY sources.list /etc/apt/sources.list


# Update and Install APACHE, PHP and PHP extensions.
# PHP and extensions installed from PPA:ondrej/php
# Be aware that some php extensions may NOT be available in all versions!
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php$VERSION \
        php$VERSION-mysql \
        php$VERSION-mcrypt \
        php$VERSION-gd \
        php$VERSION-curl \
        php-pear \
        php$VERSION-imagick \
        php$VERSION-pgsql \
        php$VERSION-json \
        php$VERSION-cli \
        php$VERSION-xdebug \
        && \
    rm -rf /var/lib/apt/lists/* && \
    EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig) && \
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
        if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php exit 1; fi && \
        php composer-setup.php --quiet && \
        rm composer-setup.php && \
        mv composer.phar /usr/local/bin/composer

# Enable php modules e.g. mcrypt
# RUN /usr/sbin/phpenmod mcrypt

# Allow .htaccess file to get parsed by apache
RUN echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf && sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf && a2enmod rewrite

# Configure /code folder with sample app
RUN mkdir -p /code

# Configure /etc/php/PHPVERSION to /etc/php_config
RUN ln -s /etc/php/$VERSION /etc/php_config

# Xdebug
RUN echo "xdebug.remote_host=" >> /etc/php_config/apache2/conf.d/20-xdebug.ini

# Expose Webserver ports
EXPOSE 80 443 9001

# Check apache health
HEALTHCHECK --interval=10s --timeout=3s --retries=6 \
    CMD curl -f http://localhost/ || exit 1

# Run Webserver
CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /etc/php_config/apache2/conf.d/20-xdebug.ini ; /usr/sbin/apache2ctl -D FOREGROUND'
