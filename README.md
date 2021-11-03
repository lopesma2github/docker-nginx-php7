# NGINX + PHP + MariaDB + PhpmyAdmin (com Docker container)

The project is a webserver based on php using nginx, running in a docker instance with our image.

Este projeto tem o objetivo de configurar um Webserver com Nginx, MariaDB e PhpmyAdmin utilizando 3 containeres Docker:

+ 1º - Container Docker com uma imagem customizada do Debian Buster.
+ 2º - MariaDB como Banco de dados
+ 3º - PhpmyAdmin para administração Web dos bancos de dados

...
## O Desenho da estrutura

![N|Solid](docs/imgs/docker-nginx-php-mysql.drawio.jpg)


O exemplo na imagem mostra uma instância EC2 da AWS. A instância esta conectada na VPC padrão e com as portas http/80 e http/443 liberadas para acesso externo.

IMPORTANTE: A porta tcp/3306 do MariaDB/MySQl não precisa ser exposta para a Internet. Logo, não é necessário inserir no Security group.

...
## Status


## Requirements

- [AWS/EC2] - Uma EC2 instalada e funcionando. (Pode ser utilizado em um computador local, mas sem o certificado SSL para o Nginx.)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)


- ### Setup


#### Docker
##### CentOS
```sh
$ sudo yum -y update && sudo yum -y install curl && curl -fsSL https://get.docker.com | bash
```
##### Debian/Ubuntu
```sh
$ sudo apt-get -y update && sudo apt-get -y install curl && curl -fsSL https://get.docker.com | bash
```

#### Docker Compose
```sh
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

### Docker image

A [image](https://hub.docker.com/r/linuxsolutions/server-web-nginx-php-fpm) ready to build your web server with Nginx and PHP-FPM.

* [Nginx 1.19.0](https://www.nginx.com/) - Web server!
* [PHP 7.4.18](https://www.php.net/) - Wordpress core Language
* [Composer 2.0.13](https://getcomposer.org/doc/00-intro.md) - Package Management
* [WP-CLI](https://developer.wordpress.org/cli/commands/) - WordPress Command Line

## Settings

The Directory `nginx/common` have all config files for Nginx

| File | About |
| ------ | ------ |
| acl.conf | Restricting Access to Proxied TCP Resources. |
| locations.conf | Define application location and access settings. | 
| php.conf | PHP upstream file  |
| security.conf | Wordpress security file |
| webp.conf | Settings file to allow changing the image format to WEBP |
| wpcommon.conf | Settings file for Wordpress Applications |
| wpsubdir.conf | Setting to enable multi-site WordPress based on subdirectories. |
| wpce-php.conf | PHP configuration supporting Plugin [Cache Enabled.](https://wordpress.org/plugins/cache-enabler/) |
| wpfc-php.conf | PHP configuration supporting Plugin [Fast CGI.](https://wordpress.org/plugins/nginx-cache/) |
| wprocket-php.conf | PHP configuration supporting Plugin [WP Rocket.](https://wpengine.com/solution-center/wp-rocket/#:~:text=WP%20Rocket%20is%20a%20premium,users%20as%20well%20as%20beginners.) |
| wpsc-php.conf | PHP configuration supporting Plugin [Super cache.](https://br.wordpress.org/plugins/wp-super-cache/) |

...
## Default settings and performance

The Directory `nginx/conf.d` configuration, performance and security files for the webserver and WordPress application.

...
- #### docker-nginx-php7/nginx/sites-enabled/

The directory `nginx/sites-enabled`  have all Settings files for sites, where define the root path, includes etc. For include new sites on server, please use the pattern below:

`example.com`
```conf
server {
  listen 80;
  listen [::]:80;
  server_name example.com;

  set $base /var/www/example.com;
	root $base/htdocs;

  index index.php index.html index.htm;

  include common/wpfc-php.conf; #Cache FastCGI
  include common/locations.conf;
  include common/wpcommon.conf;  
}
```

...
- ##### PHP
The directory `php` contains the archieve `php.ini` for change PHP configuration.


## Running

```sh
$ cd /path/docker-nginx-php7 && docker-compose up -d --build
```
* Container named: `server`.

> Note: Verify the deployment by navigating to your server address in
your preferred browser.

```sh
127.0.0.1
```

## Configure SSL

Execute:

```sh
docker-compose -f docker-compose-ssl.yml up
```

Edit:

`example.com`

```conf
server {
  listen 80;
  listen [::]:80 http2;
  server_name example.com;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;

  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
  
  server_name example.com;

  set $base /var/www/example.com;
	root $base/htdocs;

  index index.php index.html index.htm;

  include common/wpfc-php.conf; #Cache FastCGI
  include common/locations.conf;
  include common/wpcommon.conf;  
}
```

Configure Cron renew:

Execute:

```sh
$ crontab -e
```

```sh
0 0 */15 * * docker-compose -f /root/infra-design/docker-compose-ssl.yml up && docker kill -s HUP server >/dev/null 2>&1
```



## About me 
[![Github Badge](https://img.shields.io/badge/-Github-000?style=flat-square&logo=Github&logoColor=white&link=LINK_GIT)](LINK_GIT)

[![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=flat-square&logo=Linkedin&logoColor=white&link= LINK_LINKEDIN)]( LINK_LINKEDIN)




Licença
