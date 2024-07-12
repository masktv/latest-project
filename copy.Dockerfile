# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Update packages and install Apache
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apache2 \
        php7.4 \
        php7.4-mysql \
        php7.4-cli \
        php7.4-common \ 
        php7.4-gd \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-ldap \
        php7.4-curl \
        php7.4-zip \
        php7.4-json \
        phpmyadmin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN apt-get install php7.4 libapache2-mod-php7.4 && \
    apt install phpmyadmin -y   

RUN a2enmod rewrite \
    && a2enmod php7.4

# Copy Apache configuration
#COPY ./your-apache-config.conf /etc/apache2/sites-available/000-default.conf

# Allow PHP user to write files to HTML directory
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
