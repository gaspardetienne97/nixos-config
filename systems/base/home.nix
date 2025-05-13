{ config, pkgs, ... }:
{

  imports =
    [
      ../../modules/home/alacritty.nix
      ../../modules/home/bash.nix
      ../../modules/home/catppuccin.nix
      ../../modules/home/eza.nix
      ../../modules/home/firefox.nix
      ../../modules/home/git.nix
      ../../modules/home/helix.nix
      ../../modules/home/starship.nix
      ../../modules/home/vscodium.nix
      ../../modules/home/zellij.nix
      ../../modules/home/direnv.nix
      ../../modules/shared/config.nix
    ];
  modules = {
    alacritty.enable = true;
    bash.enable = true; #zsh.enable = true;
    catppuccin.enable = true;
    eza.enable = true;
    firefox.enable = true;
    git.enable = true;
    helix.enable = true;
    starship.enable = true;
    vscodium.enable = true;
    zellij.enable = true;
    direnv.enable = true;
  };




  # Common packages that don't need specific configuration
  home.packages = with pkgs;[
    bat
    bottom
    deadnix
    sops
    age
    nixd
    neofetch
    nil
    nixpkgs-fmt
    nixfmt-rfc-style
    vscode-langservers-extracted
    tailwindcss-language-server
    typescript-language-server
    svelte-language-server
    nodePackages_latest.prettier
    nerd-fonts.fira-code
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.defaultConfigurationOptions.username;
  home.homeDirectory = config.defaultConfigurationOptions.homeDirectory;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  systemd.user.services.mbsync.Unit.After = [
    "sops-nix.service"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

