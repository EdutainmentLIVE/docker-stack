#!/usr/bin/env sh

# TODO use ghcup to install ghc/stack
install_ghcup() {
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  . ~/.ghcup/env
}

install_ghc() {
  ghcup install ghc 9.0.2 --set
}

install_cabal() {
  ghcup install cabal 3.6.2.0 --set
}

install_stack() {
  ghcup install stack 2.7.5 --set
}

install_hls() {
  mkdir -p ~/.cache
  ghcup compile hls -g 9b3f3bf20e3016d20adf1f7259dc9622f8046569 --ghc 9.0.2 --set -- --ghc-options='-dynamic'
}

install_ghcup
install_ghc
install_cabal
cabal update
stack update
install_stack
install_hls
