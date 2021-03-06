FROM ubuntu:18.10
LABEL maintainer "hypermkt <hypermkt@gmail.com>"

VOLUME ["/var/www/html"]

# インタラクティブな設定を無効にする
# refs: https://qiita.com/udzura/items/576c2c782adb241070bc
RUN DEBIAN_FRONTEND=noninteractive

RUN apt-get update 

# timezone setting
RUN apt-get install -y tzdata
ENV TZ=Asia/Tokyo

# Install PHP5.6
RUN apt-get install -y -qq --no-install-recommends build-essential software-properties-common && \
  add-apt-repository -y ppa:ondrej/php && \
  apt install -y php5.6 php5.6-gd php5.6-mcrypt php5.6-mysql php5.6-curl php5.6-mbstring libapache2-mod-php5.6

# Install PECL
RUN apt install -y php5.6-xml php5.6-dev && \
  update-alternatives --set php /usr/bin/php5.6 && \
  update-alternatives --set php-config /usr/bin/php-config5.6 && \
  update-alternatives --set phpize /usr/bin/phpize5.6 && \
  pecl channel-update pecl.php.net

# Install extension via PECL
RUN apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev libssh2-1-dev
RUN pecl install imagick
RUN pecl install memcache
RUN pecl install ssh2

COPY php/imagick.ini /etc/php/5.6/mods-available/imagick.ini
COPY php/memcache.ini /etc/php/5.6/mods-available/memcache.ini
COPY php/ssh2.ini /etc/php/5.6/mods-available/ssh2.ini

RUN ln -sf /etc/php/5.6/mods-available/imagick.ini /etc/php/5.6/apache2/conf.d/20-imagick.ini && \
  ln -sf /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/apache2/conf.d/20-memcache.ini && \
  ln -sf /etc/php/5.6/mods-available/ssh2.ini /etc/php/5.6/apache2/conf.d/20-ssh2.ini && \
  ln -sf /etc/php/5.6/mods-available/imagick.ini /etc/php/5.6/cli/conf.d/20-imagick.ini && \
  ln -sf /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/cli/conf.d/20-memcache.ini && \
  ln -sf /etc/php/5.6/mods-available/ssh2.ini /etc/php/5.6/cli/conf.d/20-ssh2.ini

# Enable apache2 modules
RUN a2enmod rewrite

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
