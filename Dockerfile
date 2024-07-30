FROM moodlehq/moodle-php-apache:7.3-buster
LABEL maintainer="Wan Ding Yao <DYWAN@live.com.sg>"

ENV PHP_VERSION 7.3
ENV MOODLE_VERSION MOODLE_39_STABLE

COPY init_container.sh /bin/init_container.sh

RUN chmod 755 /bin/init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home/site" >> /etc/bash.bashrc \
    && mkdir -p /opt/startup/

COPY startup.sh /opt/startup/startup.sh
COPY cron_job.sh /opt/startup/cron_job.sh

# install sshd
RUN apt -y update \
   && apt -y install openssh-server

# configure startup
COPY sshd_config /etc/ssh/
COPY ssh_setup.sh /tmp
RUN mkdir -p /opt/startup \
   && chmod -R +x /opt/startup \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

ENV PORT 8080
ENV SSH_PORT 2222
EXPOSE 2222 8080

ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/

RUN sed -i 's!ErrorLog ${APACHE_LOG_DIR}/error.log!ErrorLog /dev/stderr!g' /etc/apache2/apache2.conf 
RUN sed -i 's!User ${APACHE_RUN_USER}!User www-data!g' /etc/apache2/apache2.conf 
RUN sed -i 's!User ${APACHE_RUN_GROUP}!Group www-data!g' /etc/apache2/apache2.conf 
RUN { \
   echo 'DirectoryIndex default.htm default.html index.htm index.html index.php hostingstart.html'; \
   echo 'ServerName localhost'; \
   echo 'CustomLog /dev/stderr combined'; \
} >> /etc/apache2/apache2.conf
RUN rm -f /usr/local/etc/php/conf.d/php.ini \
   && { \
                echo 'error_log=/dev/stderr'; \
                echo 'display_errors=Off'; \
                echo 'log_errors=On'; \
                echo 'display_startup_errors=Off'; \
                echo 'date.timezone=UTC'; \
                echo 'zend_extension=opcache'; \
    } > /usr/local/etc/php/conf.d/php.ini
RUN rm -f /etc/apache2/conf-enabled/other-vhosts-access-log.conf

# install Moodle
RUN rm -rf /var/www/html/ \
   && cd /var/www/ \
   && git clone -b ${MOODLE_VERSION} git://git.moodle.org/moodle.git /var/www/html/ \
   && mkdir /var/www/moodledata/sessions/
COPY config.php /var/www/html/config.php

# install tools
RUN apt -y install wget unzip
RUN apt -y update

# install themes
RUN cd /tmp/ \
   && wget https://moodle.org/plugins/download.php/21814/theme_trema_moodle39_2020062200.zip \
   && unzip theme_trema_moodle39_2020062200.zip \
   && mv trema/ /var/www/html/theme/trema/

# purge tools
RUN apt -y purge wget unzip

# patch admin/cron.php to prevent remote access
COPY cron_protect.sh /tmp/cron_protect.sh
RUN /tmp/cron_protect.sh

# fix permissions
RUN chmod -R 0755 /var/www/html/ \
   && chown -R www-data:www-data /var/www/moodledata/sessions/ \
   && chmod -R 0777 /var/www/moodledata/ \
   && chmod -R 0700 /opt/startup/ \
   && chmod 0700 /bin/init_container.sh

# install sudo
RUN apt -y install sudo

# cleanup
RUN rm -rf /tmp/*

WORKDIR /home/site/

ENTRYPOINT ["/bin/init_container.sh"]
