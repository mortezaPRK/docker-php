**Simple PHP app using Docker compose**

Using offical images from [Docker](https://www.docker.com)

(NGINX PHP-FPM Mysql Postgresql) AND (APACHE PHP Mysql Postgresql)
* * *

There are two type of servers. You can choose based on your needs.

**apache_ubuntu**: Web server is Apache. base image is ubuntu 16.04
<br>
**nginx_ubuntu**: Web server is NGINX. base image is php-fpm

* * *

Compose files are located in ".docker" folder. if you want to change location of this folder
<br>
remeber to make changes in conf files too. (e.g. docker-compose.yml)

You can rename ".docker" and "public_html", remember to change values in "nginx" & "apache" configuration files
<br><br>
Some of extenstions with thier dependecies are included too
<br><br>
**TODO:** I will add more type of web servers. e.g. alpine variant
<br><br>
**if you encounter any problem, open issue**