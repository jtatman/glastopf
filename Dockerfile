FROM ubuntu:18.04
MAINTAINER Lukas Rist <glaslos@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

## Install dependencies
RUN apt-get update && apt-get install -y \
        build-essential \
        g++ \
        gfortran \
        git \
        libevent-dev \
        liblapack-dev \
        libmysqlclient-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        python-beautifulsoup \
        python-chardet \
        python-dev \
        python-gevent \
        python-lxml \
        python-openssl \
        python-pip \
        python-requests \
        python-setuptools \
        python-sqlalchemy \
        python-mysqldb \
        cython \
        python-dateutil \
        python2.7 \
        python2.7-dev \
        software-properties-common \
        locales \
        php7.2 \
        php7.2-dev \
	&& \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8 && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update
RUN locale-gen en_US.UTF-8 

#RUN apt-get install -y --force-yes  php7.0 php7.0-dev
# RUN apt-get install -y php7.2 php7.2-dev


## Install and configure the PHP sandbox
RUN git clone https://github.com/mushorg/BFR.git /opt/BFR && \
    cd /opt/BFR && \
    phpize && \
    ./configure --enable-bfr && \
    make && \
    make install && \
    php -i | grep "Loaded Configuration File" && \
    echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php/7.2/cli/php.ini && \
    rm -rf /opt/BFR /tmp/* /var/tmp/*


## Install glastopf from latest sources
RUN git clone https://github.com/mushorg/glastopf.git /opt/glastopf && \
    cd /opt/glastopf && \
    python setup.py install && \
    rm -rf /opt/glastopf /tmp/* /var/tmp/*

## Configuration
RUN mkdir /opt/myhoneypot

EXPOSE 80
WORKDIR /opt/myhoneypot
CMD ["glastopf-runner"]
