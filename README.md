# drupal-testing
drupal-testing


- docker-compose -f ./docker-compose.testing.yaml build
- docker-compose -f ./docker-compose.testing.yaml up

- docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                                              NAMES
a20e320a01fd        drupal-testing_drupal-testing   "/bin/bash /start.sh"    17 seconds ago      Up 16 seconds       22/tcp, 3306/tcp, 9000/tcp, 0.0.0.0:8080->80/tcp   drupal-testing
a7f5ce4788c8        drupal-testing_mysql            "docker-entrypoint.s…"   About an hour ago   Up 16 seconds       0.0.0.0:3306->3306/tcp, 33060/tcp                  drupal-mysql

- docker exec -it a20e320a01fd /bin/bash
- cd /var/www/html/web/
- mkdir -p ./sites/default/simpletest





- ./vendor/bin/phpunit --configuration ./core --testsuite minimal
...



- ./vendor/bin/phpunit --configuration ./core ./core/modules/simpletest/tests/src/Unit
- ./vendor/bin/phpunit --configuration ./core ./core/modules/user/tests/src/Unit
- ./vendor/bin/phpunit --configuration ./core ./core/modules/datetime/tests/src/Unit
