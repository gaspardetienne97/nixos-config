# Catppuccin Theme Module
# Configures system-wide Catppuccin theme integration
# Features:
# - GTK theme support
# - Icon theme support
# - GNOME Shell theme integration
# - Configurable flavor and accent colors
{ config, lib, ... }:

{
  options.modules.catppuccin = {
    enable = lib.mkEnableOption "Catppuccin theme configuration";
  };

  config = lib.mkIf config.modules.catppuccin.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "sky";
    };
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "sky";
        gnomeShellTheme = true;
        icon.enable = true;
      };
    };
  };
}
