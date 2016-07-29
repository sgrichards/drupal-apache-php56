FROM php:5.6-apache

RUN a2enmod rewrite

# Install some packages.
RUN apt-get update
RUN apt-get install -y \
	vim \
	git \
	mysql-client \
	wget \
	iputils-ping \
	zip \
	unzip \
	nano

# install the libs and PHP extensions we need
RUN apt-get update && apt-get install -y \
  libmemcached-dev \
  libpng12-dev \
  libjpeg-dev \
  libpq-dev \
  libmcrypt-dev \
  php5-memcache \
  php5-gd \
  php5-cli \
  php5-xdebug \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip mcrypt

# Install memcached & xdebug via pecl (not supported by docker-php-ext-install atm) :(
RUN pecl install memcached xdebug

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush via composer.
RUN composer global require drush/drush:8

# Configure composer bin path for drush inside container and from exec.
RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> /root/.bashrc
ENV PATH /root/.composer/vendor/bin:$PATH
