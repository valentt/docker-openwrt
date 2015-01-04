FROM ubuntu:trusty

MAINTAINER Valent Turkovic <valent@otvorenamreza.org>

ENV DEBIAN_FRONTEND noninteractive
ENV FW_PACKAGE_HOST packages.wlan-si.net

RUN apt-get update -q -q && echo 'Europe/Berlin' > /etc/timezone && dpkg-reconfigure tzdate

RUN apt-get upgrade --yes --force-yes

RUN  apt-get -q -q update

RUN apt-get -y install build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev fakeroot ca-certificates wget openssh-server
 
RUN useradd --home-dir /builder --shell /bin/bash --no-create-home builder

RUN ./openwrt/scripts/prepare chaos_calmer trunk 42949 && \
 rm -rf .git && \
 chown -R builder:builder build

WORKDIR /buildsystem
ENV HOME /buildsystem
ADD . /buildsystem

ADD https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2 /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2

RUN cd /buildsystem && tar -xvjpf OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2

EXPOSE 22