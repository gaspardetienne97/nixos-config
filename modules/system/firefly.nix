# Firefly III Personal Finance Manager Module
# Self-hosted financial management and budgeting tool
# Features:
# - SQLite database backend
# - Secret management via sops
# - Timezone configuration
# - Reverse proxy support
{ config, lib, pkgs, ... }:

{
  options.modules.firefly = {
    enable = lib.mkEnableOption "Firefly III finance manager";
  };

  config = lib.mkIf config.modules.firefly.enable {
    sops.secrets.firefly-key = {
      owner = "firefly-iii";
    };

    services.firefly-iii = {
      enable = true;
      virtualHost = "0.0.0.0";

      settings = {
        APP_KEY_FILE = config.sops.secrets.firefly-key.path;
        DB_CONNECTION = "sqlite";
        DB_DATABASE = "firefly";
        DB_HOST = "localhost";
        DB_USERNAME = "firefly-iii";
        APP_URL = "0.0.0.0";
        TZ = "Europe/Zurich";
        TRUSTED_PROXIES = "**";
      };
    };
  };
}