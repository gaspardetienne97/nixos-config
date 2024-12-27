  # Firefox module
# Configures the Firefox web browser
# Features:
# - Minimal and fast prompt configuration
# - Disabled AWS and GCloud integrations for better performance
# - Custom prompt styling and behavior
{ config, lib, pkgs, ... }:

{
  options.modules.firefox = {
    enable = lib.mkEnableOption "Firefox web browser configuration";
  };

  config = lib.mkIf config.modules.firefox.enable {programs.firefox.enable = true;};}
