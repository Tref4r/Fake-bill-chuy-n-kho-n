# Sử dụng image PHP 8.1 với Apache
FROM php:8.1-apache

# Cài đặt các extension cần thiết (GD, mysqli, mbstring, zip, v.v.)
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli mbstring zip

# Bật mod_rewrite cho Apache
RUN a2enmod rewrite

# Đổi Apache sang port 8080 (Cloud Run yêu cầu)
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

# Copy toàn bộ source code vào container
COPY . /var/www/html/

# Thiết lập quyền cho thư mục (nếu cần)
RUN chown -R www-data:www-data /var/www/html

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Expose port 8080
EXPOSE 8080

# Thiết lập entrypoint mặc định cho Apache
CMD ["apache2-foreground"]