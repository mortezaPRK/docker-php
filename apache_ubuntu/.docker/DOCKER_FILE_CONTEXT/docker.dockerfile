FROM ubuntu:16.04


# Argument from docker-compose.yml to determine php version (7.0 or 7.1) and hostname. don't touch these :)
ARG VERSION
ARG HOSTNAME

# Uncomment to use custom apt mirror
# COPY sources.list /etc/apt/sources.list


# Update and Install APACHE, PHP and PHP extensions.
# PHP and extensions installed from PPA:ondrej/php
# Be aware that some php extensions may NOT be available in all versions!
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" > /etc/apt/sources.list.d/php.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
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
    rm -rf /var/lib/apt/lists/*

# Enable php modules e.g. mcrypt
# RUN /usr/sbin/phpenmod mcrypt

# Allow .htaccess file to get parsed by apache
RUN echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf && sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf && a2enmod rewrite

# Configure /app folder with sample app
RUN mkdir -p /code

# Configure /etc/php/PHPVERSION to /etc/php_config
RUN ln -s /etc/php/$VERSION /etc/php_config

# Expose Webserver ports
EXPOSE 80 443

# Check apache health
HEALTHCHECK --interval=10s --timeout=3s --retries=6 \
    CMD curl -f http://localhost/ || exit 1

# Run Webserver
CMD /bin/bash -c 'sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /etc/php_config/mods-available/xdebug.ini ; /usr/sbin/apache2ctl -D FOREGROUND'
