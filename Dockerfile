FROM amazonlinux:2

ARG STACK_VERSION=2.3.0.1
ENV \
  PATH=/root/.local/bin:$PATH \
  STACK_ROOT=/stack-root

RUN \
  set -o xtrace && \
  yum update -y && \
  yum install -y \
    gcc \
    git \
    gmp-devel \
    gzip \
    libc6 \
    make \
    nc \
    ncurses-devel \
    netcat-openbsd \
    perl \
    postgresql-client-9.6 \
    postgresql-devel \
    procps \
    tar \
    wget \
    xz \
    zip \
    zlib-devel && \
  cd /tmp && \
  wget \
    --output-document stack.tgz \
    --no-verbose \
    "https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64.tar.gz" && \
  tar \
    --extract \
    --file stack.tgz \
    --strip-components 1 \
    --wildcards '*/stack' && \
  rm stack.tgz && \
  mv stack /usr/local/bin/ && \
  stack --version
