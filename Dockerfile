FROM ubuntu:16.04

EXPOSE 1883
EXPOSE 9883

RUN mkdir -p /etc/mosquitto.d/
RUN mkdir -p /var/lib/mosquitto/

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y libc-ares-dev libcurl4-openssl-dev uuid-dev postgresql libpq-dev git wget tar build-essential vim

ENV PATH=/usr/local/bin:/usr/local/sbin:$PATH
ENV MOSQUITTO_VERSION=v1.4.10

# install mosquitto
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.1.tar.gz && \
    tar xvzf mosquitto-1.4.1.tar.gz
WORKDIR mosquitto-1.4.1
RUN sed -i "s/WITH_SRV:=yes/WITH_SRV=no/" config.mk
RUN make mosquitto && \
    make install

# install mosquitto-auth-plug
RUN git clone https://github.com/jpmens/mosquitto-auth-plug.git && \
    cd mosquitto-auth-plug && \
    cp config.mk.in config.mk && \
    sed -i "s/BACKEND_MYSQL ?= yes/BACKEND_MYSQL ?= no/" config.mk && \
    sed -i "s/BACKEND_POSTGRES ?= no/BACKEND_POSTGRES ?= yes/" config.mk && \
    sed -i "s/MOSQUITTO_SRC =/MOSQUITTO_SRC = ..\//" config.mk && \
    make && \
    mv auth-plug.so /etc/mosquitto/auth-plug.so

RUN echo /usr/local/lib > /etc/ld.so.conf.d/local.conf && /sbin/ldconfig

ADD mosquitto.conf /etc/mosquitto/mosquitto.conf
CMD ["/usr/local/sbin/mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]