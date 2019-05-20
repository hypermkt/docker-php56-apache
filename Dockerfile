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

RUN apt-get install -y -qq --no-install-recommends build-essential software-properties-common && \
  add-apt-repository -y ppa:ondrej/php && \
  apt install -y php5.6

EXPOSE 80
