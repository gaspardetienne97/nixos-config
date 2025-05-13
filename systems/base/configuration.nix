# Base configuration module that should be imported by all hosts
# Provides common system settings and essential packages
{ config
, lib
, pkgs
, nixpkgs
, nix-vscode-extensions
, ...
}:

{
  imports =
    [
      ../../modules/system/tailscale.nix
      ../../modules/shared/secrets.nix
      ../../modules/shared/config.nix
    ];


  modules = {
    tailscale.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    nix-vscode-extensions.overlays.default
  ];



  # System localization and timezone settings
  # These can be overridden in specific host configurations
  time.timeZone = lib.mkDefault "UTC";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Core system configuration
  system = {
    # NixOS release version - should be updated when upgrading
    stateVersion = lib.mkDefault "23.05";

    # Enable automatic system upgrades
    # Can be disabled per-host if needed
    autoUpgrade.enable = lib.mkDefault true;
  };
}
