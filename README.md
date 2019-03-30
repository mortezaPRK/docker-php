**Simple PHP app using Docker compose**

**UPDATED TO Compose V3**

Using offical images from [Docker](https://www.docker.com)

_With some PHP extension._
* * *

# Servers :

| Folder        | Server        | PHP           | Database       |
| :------------ |:-------------:| :------------:| :-------------:|
| apache_ubuntu | Apache2       | apache module | Mysql, Postgres|
| nginx_ubuntu  | NGINX         | PHP FastCGI   | Mysql, Postgres|
| nginx_alpine  | NGINX         | PHP FastCGI   | Postgres       |

<br />

#   Directory Structure:

 ### `docker`: contains docker-compose configuration files (Server, Mysql and PHP):
1.  `docker\DOCKER_FILE_CONTEXT`: contains dockerfile for server (Apache or PHP-FPM)
2.  `docker\.env`: contains variable for docker-compose file (php version, hostname, database user/pass, exposed ports)
3.  `docker\MAIN.conf`: example of nginx reverse proxy config file. It should be in `http` contex of nginx configuration
4.  `docker\php.ini`: PHP config file. with xdebug support
5.  `docker\mysql.cnf`: Mysql config file
6.  `docker\server.conf`: Apache or Nginx config file

### `app`: This folder will be mounted on server. the `public_html` folder is accessible by public

>   All files in `docker` folder have comments. read them before edit any file


### `database`: this folder will created after running server. contains database data
### `log`: this folder will created after running server. contains server log

<br />

__NOTE__
>   `database` and `log` folder needs Linux like permisson to work. if you are using Windows or Mac OS,
>   comment out mount points (`apache`: line 30,38,51 of docker-compose.yml | `nginx`: line 20,39,45,58 of docker-compose.yml)

>   There is no official Mysql for alpine version. so I did not include it in YAML file

>   to modify hostname, change `.env` file.
>   for nginx variant, you should change `server.conf` __too__

***

__Before__ run any service, read `notice` in docker.dockerfile file.

***

**TODO:**
1.  add more services. e.g. redis
2.  add datavolume to support windows and Mac
3.  add production example
4.  docker swarm
<br><br>

**if you encounter any problem, open an issue**
