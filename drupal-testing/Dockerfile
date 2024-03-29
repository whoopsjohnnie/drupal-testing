FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

# RUN apt-get update; \
#   dpkg-divert --local --rename --add /sbin/initctl; \
#   ln -sf /bin/true /sbin/initctl; \
#   apt-get -y install git curl wget supervisor openssh-server locales \
#   mariadb-client apache2 pwgen vim-tiny mc iproute2 python-setuptools \
#   unison netcat net-tools memcached nano libapache2-mod-php php php-cli php-common \
#   php-gd php-json php-mbstring php-xdebug php-mysql php-opcache php-curl \
#   php-readline php-xml php-memcached php-oauth php-bcmath; \
#   apt-get clean; \
#   apt-get autoclean; \
#   apt-get -y autoremove; \
#   rm -rf /var/lib/apt/lists/*

RUN apt-get update; \
  dpkg-divert --local --rename --add /sbin/initctl; \
  ln -sf /bin/true /sbin/initctl; \
  apt-get -y install git curl wget supervisor openssh-server locales \
  mariadb-client apache2 pwgen vim-tiny mc iproute2 python-setuptools \
  unison netcat net-tools memcached nano libapache2-mod-php php php-cli php-common \
  php-gd php-json php-mbstring php-xdebug php-mysql php-opcache php-curl \
  php-readline php-xml php-memcached php-oauth php-bcmath phpunit; \
  apt-get clean; \
  apt-get autoclean; \
  apt-get -y autoremove; \
  rm -rf /var/lib/apt/lists/*

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
  locale-gen en_US.UTF-8; \
  mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

# Install Composer, drush and drupal console
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && HOME=/ /usr/local/bin/composer global require drush/drush:~8 \
  && ln -s /.composer/vendor/drush/drush/drush /usr/local/bin/drush \
  && curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal \
  && chmod +x /usr/local/bin/drupal \
  && php --version; composer --version; drupal --version; drush --version

# Install supervisor
COPY ./files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./files/start.sh /start.sh
COPY ./files/testing.sh /testing.sh
COPY ./files/foreground.sh /etc/apache2/foreground.sh

# Apache & Xdebug
RUN rm /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/*
ADD ./files/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./files/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini
RUN a2ensite 000-default ; a2enmod rewrite vhost_alias

# Drupal new version, clean cache
ADD https://updates.drupal.org/release-history/drupal/8.x /tmp/latest.xml

# Retrieve drupal & adminer
RUN /bin/bash -t \
    && cd /var/www/html; drush -v dl drupal --dev --default-major=8 --drupal-project-rename="web" \
    && cd /var/www/html; chmod a+w web/sites/default; \
    mkdir web/sites/default/files; chown -R www-data:www-data /var/www/html/; \
    chmod -R ug+w /var/www/html/ ; \
    wget "http://www.adminer.org/latest.php" -O /var/www/html/web/adminer.php

RUN chmod 755 /start.sh /etc/apache2/foreground.sh

# 
ADD ./default.services.yml /var/www/html/web/sites/default/default.services.yml
ADD ./default.settings.php /var/www/html/web/sites/default/default.settings.php
ADD ./settings.php /var/www/html/web/sites/default/settings.php

# 
ADD ./phpunit.xml /var/www/html/web/core/phpunit.xml

WORKDIR /var/www/html

# EXPOSE 22 80 3306 9000
# CMD ["/bin/bash", "/start.sh"]

CMD ["/bin/bash", "/testing.sh"]
