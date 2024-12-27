{ config, lib, pkgs, ... }:

{
  options.modules.shell = {
    enable = lib.mkEnableOption "zsh configuration";
  };

  config = lib.mkIf config.modules.zsh.enable {

     programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          nhs = "nh os switch ${config.personalConfig.homeDirectory}/nixos-config";
          nhb = "nh os switch ${config.personalConfig.homeDirectory}/nixos-config --dry --verbose";
          clean = "nh clean all";
          uall = "sudo nixos-rebuild switch --upgrade-all";
          h = "hx .";
        };
      };

     
    };
}
