# Use the official PHP image with Apache
FROM php:8.1-apache

# Install required packages and GD extension
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite (optional, for pretty URLs)
RUN a2enmod rewrite

# Set recommended PHP.ini settings
COPY --from=php:8.1-cli /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Copy all project files into the container
COPY . /var/www/html/

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Change Apache to listen on port 8080 (Cloud Run expects this)
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

# Set working directory
WORKDIR /var/www/html
