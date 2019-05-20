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
  apt install -y php5.6 php5.6-gd php5.6-mcrypt php5.6-mysql php5.6-curl libapache2-mod-php5.6

# Install PECL
RUN apt install -y php5.6-xml php5.6-dev && \
  update-alternatives --set php /usr/bin/php5.6 && \
  update-alternatives --set php-config /usr/bin/php-config5.6 && \
  update-alternatives --set phpize /usr/bin/phpize5.6 && \
  pecl channel-update pecl.php.net

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
