# Utilizar la imagen oficial de PHP 7.3 con Apache
FROM php:8.0-apache

# Instalar las extensiones de PHP 
RUN docker-php-ext-install mysqli pdo pdo_mysql gettext zip

# Instalar y configurar la extensión GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd

# Instalar las dependencias necesarias para Composer
RUN apt-get update && apt-get install -y git zip unzip && rm -rf /var/lib/apt/lists/*

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar el directorio raíz del servidor web
ENV APACHE_DOCUMENT_ROOT /var/www/html

WORKDIR /var/www/html

COPY . ${APACHE_DOCUMENT_ROOT}/

# Ejecutar composer install
RUN composer update

# Cambiar el directorio raíz de Apache
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf