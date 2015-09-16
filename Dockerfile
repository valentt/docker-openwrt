FROM ubuntu:trusty

MAINTAINER Valent Turkovic <valent@otvorenamreza.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q -q 

RUN apt-get upgrade --yes --force-yes

RUN  apt-get -q -q update

RUN apt-get -y install build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev fakeroot ca-certificates wget openssh-server nano vim mc

RUN useradd --home-dir /builder --shell /bin/bash --no-create-home builder

WORKDIR /buildsystem
ENV HOME /buildsystem
ADD . /buildsystem

# dowload OpenWrt Imagebuilder image files
ADD https://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2 /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2
ADD http://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64.tar.bz2 /buildsystem/OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64.tar.bz2

# extract BB image and add missing repositories
RUN cd /buildsystem && tar -xvjpf OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2 && rm OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2 && chown builder:builder /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64 -R && echo "src/gz barrier_breaker_packages http://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/packages" >> /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/repositories.conf && echo "src/gz barrier_breaker_oldpackages http://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/oldpackages" >> /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/repositories.conf

# extract CC image and add fix file permissions
RUN cd /buildsystem && tar -xvjpf OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64.tar.bz2 && rm OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64.tar.bz2 && chown builder:builder /buildsystem/OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64 -R 

#RUN echo "src/gz barrier_breaker http://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/packages" >> /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/repositories.conf
 
#RUN echo "src/gz barrier_breaker_old http://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/oldpackages" >> /buildsystem/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/repositories.conf


EXPOSE 22
