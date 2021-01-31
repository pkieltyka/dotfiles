#!/usr/bin/env bash
machine=""

while true; do
    read -p "Which system are you installing on (D=Desktop L=Laptop)? " yn
    case $yn in
        [Desktop]* ) machine="desktop"; break;;
        [Laptop]* ) machine="laptop"; break;;
        * ) echo "Please answer 'D' or 'L'";;
    esac
done

# Setup machine config
if [ $machine == "desktop" ]; then
  if [[ ! -f /etc/nixos/configuration.nix ]]; then sudo ln -s $(realpath ./configuration-desktop.nix) /etc/nixos/configuration.nix; fi
  if [[ ! -f /etc/nixos/hardware-configuration.nix ]]; then sudo ln -s $(realpath ./hardware/desktop/hardware-configuration.nix) /etc/nixos/hardware-configuration.nix; fi
else
  if [[ ! -f /etc/nixos/configuration.nix ]]; then sudo ln -s $(realpath ./configuration-laptop.nix) /etc/nixos/configuration.nix; fi
  if [[ ! -f /etc/nixos/hardware-configuration.nix ]]; then sudo ln -s $(realpath ./hardware/laptop/hardware-configuration.nix) /etc/nixos/hardware-configuration.nix; fi
fi

# Machine.nix
if [[ ! -f $(realpath ~/.dotfiles/machine.nix) ]]; then
  echo "\"$machine\"" > ~/.dotfiles/machine.nix
fi

# Setup home user paths
if [[ ! -d $(realpath ~/.bin) ]]; then ln -s  $(realpath ./bin) $(realpath ~/.bin); fi
if [[ ! -d $(realpath ~/.config/nixpkgs) ]]; then ln -s $(realpath ./nixpkgs) $(realpath ~/.config/nixpkgs); fi
