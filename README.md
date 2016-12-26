**Simple PHP app using Docker compose**

Using offical images from [Docker](https://www.docker.com)

(NGINX PHP-FPM Mysql Postgresql) AND (APACHE PHP Mysql Postgresql)
* * *

There are two type off servers. You can choose based on your needs.

**apache_ubuntu**: Web server is Apache. base image is ubuntu 16.04
<br>
**nginx_ubuntu**: Web server is NGINX. base image is php-fpm which is based on ubuntu

* * *

Docker Compose files located in ".docker" folder. if you want to change location of this folder
<br>
remeber to make changes in conf files too. (e.g. docker-compose.yml)

You can rename ".docker" folder but "public_html" have been hardcoded in "nginx" configuration file
<br>
I tried to comment on every file to make it clear what is the usage of those files
<br>
Some of extenstions with thier dependecies included (only for debian-based image)
