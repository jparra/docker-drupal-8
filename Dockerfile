# from https://www.drupal.org/requirements/php#drupalversions
FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 8.0.0

RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites

# common tools
RUN apt-get update && apt-get -y  install vim nano git wget zip

# git autocomplete
RUN curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
RUN echo "source ~/.git-completion.bash" >> ~/.bashrc

# drush install
ENV DRUSH_VERSION 8.0.0-rc4

RUN wget https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar
RUN chmod +x drush.phar
RUN mv drush.phar /usr/local/bin/drush
RUN drush init

ENV TERM xterm

ADD ./scripts/install.sh /root/install.sh
