FROM ubuntu:focal-20210827

ARG USER=haskell
ARG UID=1000
ARG GID=1000

ARG DEBIAN_FRONTEND=noninteractive
ARG STACK_VERSION=2.7.3

ENV LANG=C.UTF-8

ENV PATH=/home/$USER/.ghcup/bin:/stack/bin:$PATH

# Create a default home for the default user & allow any user to sudo
RUN useradd --create-home --uid "$UID" "$USER" \
  && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Have a default work directory. Chances are your configs will override this to provide a better
# experience like terminal click to go to definition.
WORKDIR "/home/$USER"

RUN apt-get update -y \
  && apt-get install -y \
  --option=Dpkg::Options::="--force-confold" \
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
    sudo \
    tar \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
  && apt-get autoremove

# next build docker-stack develop after below should create /stack with right perms

RUN mkdir -p /stack && chown -R $USER:$USER /stack

USER "$USER"

# TODO building from scratch work without this because chown 1000 takes care of it in COPY?
# RUN mkdir -p /home/haskell/.stack/global-project/

# Copy stack.yaml with overriden packages and extra-deps
COPY --chown=$UID:$GID config.yaml /home/haskell/.stack/config.yaml
COPY --chown=$UID:$GID stack.yaml /home/haskell/.stack/global-project/stack.yaml

RUN ls -larth -R /home/haskell/.stack

COPY install.sh /home/haskell/install.sh
RUN /home/haskell/install.sh
