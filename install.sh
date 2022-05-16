#!/usr/bin/env sh

echo "path is: $PATH"

# TODO use ghcup to install ghc/stack
install_ghcup() {
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  . ~/.ghcup/env
}

install_ghc() {
  ghcup install ghc 8.10.7
  ghcup set ghc 8.10.7
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

# install_postgres_and_base() {
# sudo apt-get update -y \
#   && apt-get install -y \
#     curl \
#     gcc \
#     git \
#     gzip \
#     libgmp-dev \
#     liblzma-dev \
#     libncurses5-dev \
#     libpq-dev \
#     make \
#     netcat-openbsd\ 
#     perl \
#     postgresql-13 \ 
#     # procps \
#     sudo \
#     tar \
#     wget \
#     xz-utils \ 
#     zip \
#     zlib1g-dev \
#   && apt-get autoremove 
# }

# install_postgres_and_base
install_ghcup
echo "ghcup bin directory: "
ls -larth /home/haskell/.ghcup/bin
echo 
ghcup upgrade
install_ghc
install_cabal
cabal update
install_stack
configure_stack_use_system_ghc
