FROM amazonlinux:2.0.20200722.0

ARG STACK_VERSION=2.5.1

ENV LANG=C.UTF-8

RUN yum update -y \
  && amazon-linux-extras install postgresql11 \
  && yum install -y \
    gcc \
    git \
    gmp-devel \
    gzip \
    make \
    nc \
    ncurses-devel \
    perl \
    procps \
    sudo \
    tar \
    wget \
    xz \
    xz-devel \
    zip \
    zlib-devel \
  && yum clean all \
  && rm -rf /var/cache/yum \
  && mkdir -p /tmp/stack \
  && cd /tmp/stack \
  && wget --output-document stack.tgz --no-verbose "https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64.tar.gz" \
  && tar --extract --file stack.tgz --strip-components 1 --wildcards '*/stack' \
  && mv stack /usr/local/bin/ \
  && cd - \
  && rm -r /tmp/stack
