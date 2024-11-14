{ pkgs, ... }:
{

  # Define personal configuration options
  options.personalConfig = {
    username = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "gaspard";
    };
    fullName = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "Gaspard Michel Etienne";
    };
    email = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "gaspardetienne97@gmail.com";
    };
    homeDirectory = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "/home/gaspard";
    };
    hostName = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "nixos";
    };
    websiteHostName = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "gaspardetienne.com";
    };
    timezone = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "America/New_York";
    };
    locale = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "en_US.UTF-8";
    };
    editor = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "hx";
    };
  };
  config = {
    personalConfig = {
      username = "gaspard";
      fullName = "Gaspard Michel Etienne";
      email = "gaspardetienne97@gmail.com";
      homeDirectory = "/home/gaspard";
      hostName = "nixos";
      websiteHostName = "gaspardetienne.com";
      timezone = "America/New_York";
      locale = "en_US.UTF-8";
      editor = "hx";
    };
  };
}