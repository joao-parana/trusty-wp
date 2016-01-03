#!/bin/bash

# Verify if file /.mysql_db_created exists !
if [ -f /.mysql_db_created ];
then
  exec supervisord -n
  exit 1
fi

# Waiting 5 seconds
sleep 5
echo "••• `date` - Verifying if DB wordpress EXISTS. Using Environment Variables:"
echo "••• `date` - MYSQL_PORT_3306_TCP_ADDR=$MYSQL_PORT_3306_TCP_ADDR"
echo "••• `date` - MYSQL_PORT_3306_TCP_PORT=$MYSQL_PORT_3306_TCP_PORT"
echo "••• `date` - MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD"
echo "••• `date` - Using MySQL User root to connect "

DEBUB_MSG=$(mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_PORT_3306_TCP_ADDR -P$MYSQL_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE 'wordpress';")
echo "••• `date` - DEBUB_MSG='$DEBUB_MSG'"

DB_EXISTS=$(mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_PORT_3306_TCP_ADDR -P$MYSQL_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE 'wordpress';" | grep "wordpress" > /dev/null; echo "$?")
echo "••• `date` - Result: DB_EXISTS=$DB_EXISTS"

WP_VERSION="4.4"

if [[ DB_EXISTS -eq 1 ]];
then
  echo "••• `date` - Creating database wordpress for Wordpress $WP_VERSION"
  RET=1
  while [[ RET -ne 0 ]]; do
    sleep 5
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_PORT_3306_TCP_ADDR \
          -P$MYSQL_PORT_3306_TCP_PORT -e "CREATE DATABASE wordpress"
    RET=$?
  done
  echo "••• `date` - Database wordpress for Wordpress $WP_VERSION was created!"
else
  echo "••• `date` - Skipped creation of database wordpress for Wordpress $WP_VERSION – it already exists."
fi

touch /.mysql_db_created

echo "••• `date` - /var/www/html directory"
ls -la /var/www/html

echo "••• `date` - /etc/supervisor/conf.d/supervisord-apache2.conf file content"
cat /etc/supervisor/conf.d/supervisord-apache2.conf
echo "••• `date` - /start.sh file content"
cat /start.sh
echo "••• `date` - /etc/apache2/envvars file content"
cat /etc/apache2/envvars | egrep -v "^#"
echo "••• `date` - /var/log/apache2 directory"
ls -lat /var/log/apache2
echo "••• `date` - supervisord take the control"

exec supervisord -n
