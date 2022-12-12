FROM ubuntu:22.04

RUN apt-get update -qq \
    && apt-get install -y \
               curl \
               wget \
               git \
               build-essential \
               zlib1g zlib1g-dev \
               libssl-dev \
    && adduser --quiet \
               --disabled-password \
               --shell /bin/bash \
               --home /home/app \
               --gecos "User" \
               app

RUN wget -O ruby-install-0.8.5.tar.gz https://github.com/postmodern/ruby-install/archive/v0.8.5.tar.gz \
    && tar -xzvf ruby-install-0.8.5.tar.gz \
    && cd ruby-install-0.8.5/ \
    && make install

ONBUILD ARG RUBY_VERSION
ONBUILD USER root
ONBUILD RUN ruby-install --system $RUBY_VERSION
ONBUILD USER app
ONBUILD WORKDIR /app

ENV GEM_HOME="$HOME/.gems"
ENV GEM_PATH="$HOME/.gems${GEM_PATH:+:}$GEM_PATH"
ENV PATH="$HOME/.gems/bin${PATH:+:}$PATH"
