FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get install -y \
               curl \
               wget \
               git \
               build-essential \
               zlib1g zlib1g-dev \
               libssl-dev \
               lsb-release \
               tzdata \
    && adduser --quiet \
               --disabled-password \
               --shell /bin/bash \
               --home /home/app \
               --gecos "User" \
               app \
    && mkdir /home/app/.gems \
    && chown app:app /home/app/.gems

ARG RUBY_BUILD=20221206
RUN wget -O ruby-build-$RUBY_BUILD.tar.gz https://github.com/rbenv/ruby-build/archive/refs/tags/v$RUBY_BUILD.tar.gz \
    && tar -xvzf  ruby-build-$RUBY_BUILD.tar.gz \
    && cd ruby-build-$RUBY_BUILD/ \
    && ./install.sh

RUN apt install curl ca-certificates gnupg \
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get -qq update

ONBUILD ARG RUBY_VERSION
ONBUILD USER root
ONBUILD RUN sh -c "[ ! -z "$RUBY_VERSION" ] && ruby-build $RUBY_VERSION /usr/local || true"

ONBUILD ARG PG_VERSION
ONBUILD USER root
ONBUILD RUN sh -c "[ ! -z "$PG_VERSION" ] && apt-get -yq install postgresql-client-$PG_VERSION postgresql-server-dev-$PG_VERSION || true"

ONBUILD ARG NODE_MAJOR
ONBUILD USER root
ONBUILD RUN sh -c "[ ! -z "$NODE_MAJOR" ] && (curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && apt-get install -y nodejs) || true"

ONBUILD USER app
ONBUILD WORKDIR /app

ENV GEM_HOME="/home/app/.gems"
ENV GEM_PATH="/home/app/.gems${GEM_PATH:+:}$GEM_PATH"
ENV PATH="/home/app/.gems/bin${PATH:+:}$PATH"
