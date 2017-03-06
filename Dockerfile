FROM centos:centos6

# File Author / Maintainer
MAINTAINER Daniel Galvao <daniel.galvao@justdigital.com.br>

# Installing tools
RUN yum install -y yum-utils tar wget git

# Installing nginx 
ADD nginx.repo /etc/yum.repos.d/
RUN yum install -y nginx
RUN yum -y install epel-release && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum-config-manager -q --enable remi && \
    yum-config-manager -q --enable remi-php56

# Installing php-fpm and php extensions
RUN yum install -y php-fpm php-common memcached
RUN yum install -y php-pecl-apc php-cli php-pear php-pdo php-mysql php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-adodb php-imap php-intl php-soap
RUN yum install -y php-mysqli php-zip php-iconv php-curl php-simplexml php-dom php-bcmath php-opcache

# Clean up yum repos to save spaces
RUN yum update -y && yum clean all

# Install supervisor
RUN easy_install supervisor

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

# Adding the default file
ADD index.php /var/www/index.php

VOLUME ["/data"]

EXPOSE 80 443

#https://hub.docker.com/r/johnnyzheng/centos-nginx-php/~/dockerfile/
#https://hub.docker.com/r/johnnyzheng/centos-nginx-php/~/dockerfile/
