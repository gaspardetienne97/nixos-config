{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/git.nix
    ../../modules/starship.nix
    ../../modules/zellij.nix
    ../../modules/shell.nix
    ../../modules/programs.nix
  ];

  modules = {
    base.enable = true;
    git.enable = true;
    starship.enable = true;
    zellij.enable = true;
    shell.enable = true;
  };

  # Host-specific overrides
  programs.alacritty.settings.window.opacity = 1.0;
}
