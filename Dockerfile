FROM parana/trusty-php

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2016-01-03

# Install packages
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
 apt-get -y install mysql-client

WORKDIR /tmp

# Download Wordpress into /app
RUN rm -rf /app && mkdir /app && \
 curl -L -O https://wordpress.org/wordpress-4.4.tar.gz && \
 tar -xzvf wordpress-4.4.tar.gz -C /app --strip-components=1 && \
 rm wordpress-4.4.tar.gz

# If you prefer you can add wp-config with info for Wordpress to connect to DB
# ADD wp-config.php /app/wp-config.php
# RUN chmod 644 /app/wp-config.php

# Or leave it alone and run a shell script to customize
RUN ls -lat /app && cat /app/wp-config-sample.php

# Fix permissions for apache
RUN chown -R www-data:www-data /app

# Add script to create 'wordpress' DB
ADD run-wp.sh /run-wp.sh
RUN chmod 755 /*.sh

WORKDIR /app

EXPOSE 80

CMD ["/run-wp.sh"]
