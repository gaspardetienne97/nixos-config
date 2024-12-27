# qBittorrent Module
# Configures the qBittorrent torrent client
# Features:
# - User-specific installation
# - Integration with home-manager
{ config, lib, pkgs, ... }:

{
  options.modules.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent client";
  };

  config = lib.mkIf config.modules.qbittorrent.enable {

      home.packages =  [ pkgs.qbittorrent ];

  };

}
