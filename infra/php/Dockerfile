FROM php:8.1-fpm-alpine

RUN apk add --no-cache git

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions intl mcrypt pdo_mysql xdebug @composer

RUN git config --global --add safe.directory '/bookme'

WORKDIR /bookme

CMD php-fpm

EXPOSE 9000
