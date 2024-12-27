# Zellij Terminal Multiplexer Module
# Provides a modern terminal multiplexer with a user-friendly interface
# Features:
# - Multiple terminal panes and tabs
# - Compact layout configuration
# - Session management
{ config, lib, pkgs, ... }:

{
  options.modules.zellij = {
    enable = lib.mkEnableOption "Zellij terminal multiplexer";
  };

  config = lib.mkIf config.modules.zellij.enable {
    home.packages = [ pkgs.zellij ];
    programs.zellij = {
      enable = true;
      settings = {
        default_layout = "compact";
      };
    };
  };
}
