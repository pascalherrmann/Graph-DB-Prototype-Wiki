###### Image basiert auf PHP + Apache-Server ######
FROM php:7.1-apache

MAINTAINER Pascal Herrmann

# Backend kopieren (PHP-Dateien) - muss in /var/www
COPY ./backend /var/www/backend

# Frontend kopieren (JS) - muss immer in html
COPY ./public /var/www/html

###### Apache Konfiguration ######
# Rewrite für htaccess aktivieren #
RUN a2enmod rewrite

COPY ./backend/php.ini /usr/local/etc/php/

#### Composer install & Update #####
RUN cd /var/www/html

RUN apt-get update && apt-get install -y git zip unzip vim

RUN docker-php-ext-install bcmath

WORKDIR /var/www/backend

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
php composer-setup.php &&\
php -r "unlink('composer-setup.php');"


RUN ./composer.phar install

WORKDIR /var/www/html

RUN chmod 777 -R /var/www/backend/storage/

