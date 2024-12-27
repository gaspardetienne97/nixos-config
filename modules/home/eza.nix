# Eza Module (Modern ls replacement)
# Configures the modern replacement for ls command
# Features:
# - Git integration
# - Icons support
# - Color output
{ config, lib, pkgs, ... }:

{
  options.modules.eza = {
    enable = lib.mkEnableOption "Eza ls replacement";
  };

  config = lib.mkIf config.modules.eza.enable {
    programs.eza = {
        enable = true;
        git = true;
        icons = true;
      };
  };
}
