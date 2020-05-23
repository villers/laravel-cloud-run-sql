FROM php:7.4-apache as prod

# Set working directory
WORKDIR /var/www/html

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
ENV PORT 80

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install system dependencies
RUN apt-get update \
    && apt-get install -y \
        git \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install apcu-5.1.18; \
    pecl clear-cache;

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd opcache
RUN docker-php-ext-enable apcu

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add the composer.json
COPY ./composer.* ./
COPY ./database ./database
RUN composer install --no-scripts --no-dev

# Copy all files
COPY . ./
RUN chmod -R 777 storage
RUN composer install --classmap-authoritative --no-dev

# Configure image
COPY .cloud/docker/php/image-root /

RUN a2enmod rewrite
