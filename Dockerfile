FROM ubuntu:focal-20210416

ARG DEBIAN_FRONTEND=noninteractive
ARG STACK_VERSION=2.7.1

ENV LANG=C.UTF-8

# Make sure this path includes initdb for the usage of tmp-postgres
ENV PATH=/usr/lib/postgresql/12/bin/:$PATH

RUN apt-get update -y \
  && apt-get install -y \
    curl \
    gcc \
    git \
    gzip \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libpq-dev \
    make \
    netcat-openbsd \
    perl \
    postgresql-12 \
    procps \
    sudo \
    tar \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
  && apt-get autoremove \
  && mkdir -p /tmp/stack \
  && cd /tmp/stack \
  && wget --output-document stack.tgz --no-verbose "https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64.tar.gz" \
  && tar --extract --file stack.tgz --strip-components 1 --wildcards '*/stack' \
  && mv stack /usr/local/bin/ \
  && cd - \
  && rm -r /tmp/stack
