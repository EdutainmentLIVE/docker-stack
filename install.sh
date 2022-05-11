#!/usr/bin/env sh

export PATH="$HOME/.ghcup/bin:$PATH"

# TODO use ghcup to install ghc/stack
install_ghcup() {
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  source ~/.ghcup/env
}

install_cabal() {
  ghcup upgrade
  ghcup install cabal 3.6.2.0
  ghcup set cabal 3.6.2.0
}

install_stack() {
  ghcup install stack
  # ghcup set stack 2.7.3 # this doesn't work
}

configure_stack_use_system_ghc() {
    stack config set install-ghc false --global
    stack config set system-ghc  true  --global
}

install_postgres_and_base() {
apt-get update -y \
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
    netcat-openbsd\ 
    perl \
    postgresql-13 \ 
    # procps \
    sudo \
    tar \
    wget \
    xz-utils \ 
    zip \
    zlib1g-dev \
  && apt-get autoremove 
}

install_postgres_and_base
install_ghcup
ghcup upgrade
install_ghc
install_cabal
cabal update
install_stack
configure_stack_use_system_ghc
