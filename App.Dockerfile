# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Update packages and install Apache
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apache2 \
        php7.4 \
        libapache2-mod-php7.4 \
        php7.4-mysql \
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
RUN a2enmod php7.4 \
    && a2enmod rewrite

# for phpmyadmin configuration 
RUN echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Copy Apache site-setting configuration
RUN  rm /etc/apache2/sites-enabled/000-default.conf
COPY ./domain.conf /etc/apache2/sites-enabled
COPY ./subdomain.conf /etc/apache2/sites-enabled
COPY ./subdomain1.conf /etc/apache2/sites-enabled

# Install AWS CLI using pip (Python package installer)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
    && pip3 install --upgrade pip \
    && pip3 install awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download public_html from S3 to /var/www/html
RUN aws s3 cp s3://application-automation/public_html/ /var/www/html --recursive


# Allow PHP user to write files to HTML directory
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

