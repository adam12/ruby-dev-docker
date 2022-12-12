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

ARG RUBY_BUILD=20221206
RUN wget -O ruby-build-$RUBY_BUILD.tar.gz https://github.com/rbenv/ruby-build/archive/refs/tags/v$RUBY_BUILD.tar.gz \
    && tar -xvzf  ruby-build-$RUBY_BUILD.tar.gz \
    && cd ruby-build-$RUBY_BUILD/ \
    && ./install.sh

ONBUILD ARG RUBY_VERSION
ONBUILD USER root
ONBUILD RUN ruby-build $RUBY_VERSION /usr/local
ONBUILD USER app
ONBUILD WORKDIR /app

ENV GEM_HOME="$HOME/.gems"
ENV GEM_PATH="$HOME/.gems${GEM_PATH:+:}$GEM_PATH"
ENV PATH="$HOME/.gems/bin${PATH:+:}$PATH"
