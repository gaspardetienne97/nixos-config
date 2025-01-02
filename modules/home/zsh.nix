{ config, lib, pkgs, ... }:

{
  options.modules.zsh = {
    enable = lib.mkEnableOption "zsh configuration";
  };

  config = lib.mkIf config.modules.zsh.enable {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      #TODO: refactor aliases to my default config module
      shellAliases = {
        nhs = "nh os switch ${config.defaultConfigurationOptions.homeDirectory}/nixos-config";
        nhb = "nh os switch ${config.defaultConfigurationOptions.homeDirectory}/nixos-config --dry --verbose";
        clean = "nh clean all";
        uall = "sudo nixos-rebuild switch --upgrade-all";
        h = "hx .";
      };
    };
  };
}
