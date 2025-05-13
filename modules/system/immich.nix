{ lib, config, pkgs, ... }:
{
  options.modules.immich = {
    enable = lib.mkEnableOption "immich service";
  };

  config = lib.mkIf config.modules.immich.enable {

    users.users.immich.extraGroups = [ "video" "render" ];

    services.immich = {
      enable = true;
      # package = pkgs.immich;
      port = 2283;

      #openFirewall = true;

      redis = {
        enable = true;
        host = "127.0.0.1";
        port = 6363;
      };
    };
  };
}
