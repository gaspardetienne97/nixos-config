# Git version control module
# Configures Git with user-specific settings and common configurations
# Uses personalConfig values for user identity
# Can be extended with additional Git configurations as needed
{ config, lib, pkgs, ... }:

{
  options.modules.git = {
    enable = lib.mkEnableOption "Git configuration";
  };

  config = lib.mkIf config.modules.git.enable {
    home.packages = [ pkgs.git ];

    programs.git = {
      enable = true;
      userName = config.personalConfig.fullName;
      userEmail = config.personalConfig.email;
    };
  };
}
