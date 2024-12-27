# Direnv Module
# Loads and unloads environment variables depending on the current directory
# Features:
# - Automatic environment switching
# - Nix shell integration
# - Bash shell integration
{ config, lib, pkgs, ... }:

{
  options.modules.direnv = {
    enable = lib.mkEnableOption "Direnv directory environment";
  };

  config = lib.mkIf config.modules.direnv.enable {
    programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

  };
}
