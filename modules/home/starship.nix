# Starship prompt module
# Configures the Starship cross-shell prompt
# Features:
# - Minimal and fast prompt configuration
# - Disabled AWS and GCloud integrations for better performance
# - Custom prompt styling and behavior
{ config, lib, pkgs, ... }:

{
  options.modules.starship = {
    enable = lib.mkEnableOption "Starship prompt configuration";
  };

  config = lib.mkIf config.modules.starship.enable {
    home.packages = [ pkgs.starship ];
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
  };
}
