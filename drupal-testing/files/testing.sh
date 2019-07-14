#!/bin/bash

# 
# # /var/www/html/web
# # ./vendor/bin/phpunit --configuration ./core --testsuite minimal
# CMD ["/bin/bash", "cd /var/www/html/web && ./vendor/bin/phpunit --configuration ./core --testsuite minimal"]
# 
# 

mkdir -p /var/www/html/web/sites/default/simpletest

cd /var/www/html/web

./vendor/bin/phpunit --configuration ./core --testsuite minimal
