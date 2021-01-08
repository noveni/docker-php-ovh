FROM php:7.2-fpm
RUN apt-get update && apt-get install -y \
                                apt-utils \
                                libbz2-dev \
                                libssl-dev \
                                unzip \
                                libxslt-dev \
                                libpspell-dev \
                                libpq-dev
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install bz2
RUN docker-php-ext-install calendar
RUN docker-php-ext-install dba
RUN docker-php-ext-install exif
RUN docker-php-ext-install ftp

RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install gettext
RUN apt install -y libgmp-dev

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

RUN docker-php-ext-install gmp
RUN apt-get install -y libmhash-dev
RUN docker-php-ext-configure hash --with-mhash

RUN apt-get install -y libmagickwand-dev
RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN apt-get install -y \
                libc-client-dev \
                libkrb5-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN apt install -y libicu-dev
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN apt install -y libmcrypt-dev

RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev

RUN pecl install memcached \
    && docker-php-ext-enable memcached

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pspell
RUN docker-php-ext-install soap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install sysvmsg
RUN docker-php-ext-install sysvsem
RUN docker-php-ext-install sysvshm
RUN docker-php-ext-install wddx
RUN docker-php-ext-install xsl
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip

RUN pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug
# Use the default production configuration

RUN apt-get install -y git

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY config/php.ini /usr/local/etc/php/phpcustom.ini

WORKDIR /var/www/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
