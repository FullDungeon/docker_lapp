FROM php:8.0-apache


# добавить пользователя
ENV GID 1000
ENV UID 1000
RUN groupadd -g ${GID} developer && \
    useradd -u ${UID} -g developer -m developer -G root,www-data && \
    usermod -p "*" developer -s /bin/bash && \
    usermod -aG www-data developer

# установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    build-essential \
    wget \
    zip \
    unzip \
    bzip2 \
    libzip-dev \
    libbz2-dev \
    libfontconfig \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libmcrypt-dev \
    libpq-dev

RUN docker-php-ext-install \
    pgsql \
    pdo_pgsql

# установка composer
COPY ./apache2/apache2.conf /etc/apache2/apache2.conf
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# конфигурация apache
ENV APACHE_DOCUMENT_ROOT /var/www
ENV APACHE_RUN_USER #1000
ENV APACHE_RUN_GROUP #1000
RUN a2enmod rewrite headers expires


WORKDIR /var/www/