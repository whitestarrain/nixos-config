set shell := ["bash", "-ce"]
proxy := "http://127.0.0.1:7890"

default:
  @just --list

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# garbage collect all unused nix store entries that older than 7d
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

# clear old generations and gc
[group('nix')]
force_gc:
  # clear old profiles
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  # gc
  sudo nix-collect-garbage --delete-old
  # run the gc command as current user because the issue: https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-old
  # rebuild to clear boot entries in /boot/loader
  sudo nixos-rebuild switch

# rebuild system
[linux]
[group('nix')]
rebuild:
  # rebuild to generate current generation
  sudo nixos-rebuild switch

# rebuild system through china's mirror
[linux]
[group('nix')]
rebuild-cn:
  # rebuild to generate current generation
  sudo nixos-rebuild switch --option substituters https://mirrors.ustc.edu.cn/nix-channels/store

# rebuild system through proxy
[linux]
[group('nix')]
rebuild-proxy:
  #!/usr/bin/env bash
  # add proxy config
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
  sudo bash -c 'cat > /run/systemd/system/nix-daemon.service.d/override.conf << EOF
  [Service]
  Environment="http_proxy={{proxy}}"
  Environment="https_proxy={{proxy}}"
  Environment="all_proxy={{proxy}}"
  EOF'
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
  # rebuild
  sudo nixos-rebuild switch
  # clear proxy config
  sudo rm /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

# rebuild system and clear all old generation
[linux]
[group('nix')]
force_refresh_build:
  # rebuild to generate current generation
  sudo nixos-rebuild switch
  # clear old profiles
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  # gc
  sudo nix-collect-garbage --delete-old
  # run the gc command as current user because the issue: https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-old
  # rebuild to clear boot entries in /boot/loader
  sudo nixos-rebuild switch

# list system generations
[linux]
[group('nix')]
list-generations:
  sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Update all the flake inputs
[group('nix')]
update:
  nix flake update

# Update specific input
[group('nix')]
update-package input:
  nix flake update {{input}}
