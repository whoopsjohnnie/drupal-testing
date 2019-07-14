# FROM mysql
FROM mysql:5.7

# Add a database
ENV MYSQL_ROOT_PASSWORD $MYSQL_ROOT_PASSWORD
ENV MYSQL_DATABASE $MYSQL_DATABASE
ENV MYSQL_USER $MYSQL_USER
ENV MYSQL_PASSWORD $MYSQL_PASSWORD

# Add the content of the sql-scripts/ directory to your image
# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup
COPY ./sql/drupal.sql /docker-entrypoint-initdb.d/
