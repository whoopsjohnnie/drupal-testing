FROM drupal:8-apache

RUN apt-get update \
    && apt-get install -y mariadb-client git \
    && rm -rf /var/lib/apt/lists/*

ADD ./default.services.yml /var/www/html/sites/default/default.services.yml
ADD ./default.settings.php /var/www/html/sites/default/default.settings.php
ADD ./settings.php /var/www/html/sites/default/settings.php

WORKDIR "/var/www/html"

# EXPOSE 80
# CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
