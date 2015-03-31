#!/bin/sh

NIXLIB=$HOME/Library/Nix
NIXPKGS=${NIXLIB}/nixpkgs

function install_nix() {
  echo "Installing nix..."
  curl https://nixos.org/nix/install | sh
  . $HOME/.nix-profile/etc/profile.d/nix.sh
}

function install_nixpkgs() {
  echo "Downloading nixpkgs..."
  mkdir -p ${NIXLIB}
  pushd ${NIXLIB}
  git clone https://github.com/NixOS/nixpkgs.git
  popd
}

function configure_nixpkgs() {
  echo "Refreshing nixpkgs..."
  nix-channel --remove nixpkgs
  pushd $HOME/.nix-defexpr
  rm -rf *
  ln -s ${NIXPKGS} nixpkgs
  popd
}

function enable_binarycache() {
  echo "Adding binary cache repository..."
  sudo mkdir /etc/nix
  sudo echo "binary-caches = http://cache.nixos.org/" > /etc/nix/nix.conf
}

function finale() {
  echo "Please add a line below to your xxxrc."
  echo "export NIX_PATH=${NIXPKGS}:nixpkgs=${NIXPKGS}"
}

function main() {
    install_nix
    install_nixpkgs
    configure_nixpkgs
    enable_binarycache
    finale
}

main
