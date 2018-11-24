FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
                                apt-utils \
                                libbz2-dev \
                                libc-client-dev \
                                libfreetype6-dev \
                                libjpeg62-turbo-dev \
                                libgmp-dev \
                                libicu-dev \
                                libkrb5-dev \
                                libmagickwand-dev \
                                libmemcached-dev \
                                libmcrypt-dev \
                                libmhash-dev \
                                libpng-dev \
                                libpq-dev \
                                libpspell-dev \
                                libssl-dev \
                                libxslt-dev \
                                git-all \
                                zlib1g-dev \
                                && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick \
                memcached \
                mongodb \
                redis-3.1.2

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure hash --with-mhash
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl

RUN docker-php-ext-install bcmath \
                            bz2 \
                            calendar \
                            dba \
                            exif \
                            ftp \
                            -j$(nproc) gd \
                            gettext \
                            gmp \
                            imap \
                            -j$(nproc) intl \
                            mbstring \
                            mysqli \
                            pdo_mysql \
                            pdo_pgsql \
                            pgsql \
                            pspell \
                            soap \
                            sockets \
                            sysvmsg \
                            sysvsem \
                            sysvshm \
                            wddx \
                            xsl \
                            xmlrpc \
                            opcache \
                            zip

RUN docker-php-ext-enable imagick \
                        memcached \
                        mongodb \
                        redis

RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN { \
        echo '[xdebug]'; \
        echo 'xdebug.default_enable = 0'; \
    } >> /usr/local/etc/php/conf.d/xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
