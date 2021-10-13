FROM ubuntu:focal-20210827

ARG DEBIAN_FRONTEND=noninteractive
ARG STACK_VERSION=2.7.3

ENV LANG=C.UTF-8

# Make sure this path includes initdb for the usage of tmp-postgres
ENV PATH=/usr/lib/postgresql/13/bin/:$PATH

RUN apt-get update -y && apt-get install -y gnupg curl ca-certificates
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
RUN echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

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
    postgresql-13 \
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
