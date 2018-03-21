FROM debian:stretch

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y crossbuild-essential-armhf \
                       libpciaccess-dev:armhf \
                       libkmod-dev:armhf \
                       libprocps-dev:armhf \
                       libcairo2-dev:armhf \
                       libunwind-dev:armhf \
                       libudev-dev:armhf \
                       git \
                       autoconf \
                       xutils-dev \
                       autogen \
                       libtool \
                       libnss-wrapper \
                       python \
                       python-requests
