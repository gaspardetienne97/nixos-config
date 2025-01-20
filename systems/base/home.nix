{ config, pkgs, ... }:
{

  imports =
    # Import all .nix files from modules directory
    let
      modulesDir = ../../modules/home;
      moduleFiles = builtins.filter
        (name: builtins.match ".*\\.nix" name != null)
        (builtins.attrNames (builtins.readDir modulesDir));
    in
    (map (file: modulesDir + "/${file}") moduleFiles) ++ [
      ../../modules/shared/config.nix
    ]
  ;



  # Common packages that don't need specific configuration
  home.packages = with pkgs;[
    bat
    bottom
    code-cursor
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
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
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

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
