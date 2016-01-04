FROM parana/trusty-php

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2016-01-04

# Install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
    apt-get -y install mysql-client && \
    apt-get -y install build-essential ssmtp

WORKDIR /tmp

# Download Wordpress into /app
RUN rm -rf /app && mkdir /app && \
    curl -L -O https://wordpress.org/wordpress-4.4.tar.gz && \
    tar -xzvf wordpress-4.4.tar.gz -C /app --strip-components=1 && \
    rm wordpress-4.4.tar.gz

RUN apt-get update && \
    apt-get -y install mailutils mutt nano

RUN mkdir -p /root/ssmtp/conf && mkdir -p/root/php/conf
COPY conf/smtp/ssmtp.conf /root/ssmtp/conf
COPY conf/php/php.ini /root/php/conf/php.ini
RUN echo "••• Configuração original do SMTP •••" && \
    cat /etc/ssmtp/ssmtp.conf && \
    echo "•••••••••••••••••••••••••••••••••••••"

# Merging my .GMAILRC into ssmtp.conf file
COPY conf/smtp/.GMAILRC /root/ssmtp/conf
RUN cat /root/ssmtp/conf/.GMAILRC >> /etc/ssmtp/ssmtp.conf
COPY conf/smtp/container-started-message.txt /root/ssmtp/conf

# If you prefer you can add wp-config with info for Wordpress to connect to DB
# ADD wp-config.php /app/wp-config.php
# RUN chmod 644 /app/wp-config.php

# Or leave it alone and run a shell script to customize
RUN ls -lat /app && cat /app/wp-config-sample.php

# Fix permissions for apache
RUN chown -R www-data:www-data /app
# Add home for custom plugins and themes provided by VOLUME
RUN mkdir -p /app/custom
RUN chown -R www-data:www-data /app/custom

# Add script to create 'wordpress' DB
ADD run-wp.sh /run-wp.sh
RUN chmod 755 /*.sh

WORKDIR /app

# Plugins and themes customization
VOLUME ["/app/custom"]
RUN ls -lat /app/custom

ENV PHPINI_FULL_FILENAME='/etc/php5/apache2/php.ini'
RUN cat $PHPINI_FULL_FILENAME | egrep -v "^;" | egrep "mail|smtp|SMTP"

EXPOSE 80

CMD ["/run-wp.sh"]
