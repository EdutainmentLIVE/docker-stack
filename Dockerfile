FROM amazonlinux:2

ARG STACK_VERSION=2.1.3
ENV \
  PATH=/root/.local/bin:$PATH \
  STACK_ROOT=/stack-root

RUN \
  set -o xtrace && \
  yum update -y && \
  yum install -y \
    gcc \
    git \
    libgmp-dev \
    libpq-dev \
    libtinfo-dev \
    make \
    netbase \
    wget \
    xz-utils \
    zlib1g-dev && \
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
  stack upgrade --git && \
  rm -r /stack-root && \
  stack --version
