FROM php:8.0-fpm
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
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install gettext
RUN apt-get install -y libgmp-dev

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
RUN apt-get install -y libicu-dev
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install intl
RUN apt-get install -y libonig-dev
RUN docker-php-ext-install mbstring
RUN apt-get install -y libmcrypt-dev

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
RUN docker-php-ext-install xsl
RUN docker-php-ext-install xml
RUN docker-php-ext-install opcache
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# install localisation
RUN apt-get update && \
    # locales
    apt-get install -y locales locales-all

RUN pecl install redis
RUN pecl install xdebug \
    && docker-php-ext-enable redis xdebug
# Use the default production configuration

RUN apt-get install -y git

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY config/php.ini /usr/local/etc/php/phpcustom.ini

WORKDIR /var/www/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# https://towardsdatascience.com/slimming-down-your-docker-images-275f0ca9337e
