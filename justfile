set shell := ["bash", "-ce"]

default:
  @just --list

[private]
set-proxy:
  export http_proxy=http://127.0.0.1:7890
  export https_proxy=http://127.0.0.1:7890
  export all_proxy=http://127.0.0.1:7890

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

# rebuild system and clear all old generation
[linux]
[group('nix')]
force_refresh_build:
  sudo nixos-rebuild switch
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old
  sudo nixos-rebuild switch

# Update all the flake inputs
[group('nix')]
update:
  nix flake update

# Update specific input
[group('nix')]
update-package input:
  nix flake update {{input}}
