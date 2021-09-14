FROM php:8.0-fpm

RUN apt-get update -y && apt-get install -y libpng-dev zlib1g-dev mariadb-client

RUN docker-php-ext-install mysqli gd

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN export PAGER='busybox less'