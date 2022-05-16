#!/usr/bin/env sh

# TODO use ghcup to install ghc/stack
install_ghcup() {
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_MINIMAL=1
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  . ~/.ghcup/env
}

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
