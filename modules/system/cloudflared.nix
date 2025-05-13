# Cloudflared Module
# Manages Cloudflare Tunnel for secure service exposure
# Features:
# - Automatic tunnel configuration
# - TLS certificate management
# - Local service proxying
# - Custom domain routing
{ config, lib, pkgs, ... }:

{
  options.modules.cloudflared = {
    enable = lib.mkEnableOption "Cloudflare Tunnel service";
  };

  config = lib.mkIf config.modules.cloudflared.enable {
    environment.systemPackages = [ pkgs.cloudflared ];
    services.cloudflared = {
      user = config.defaultConfigurationOptions.username;
      enable = true;
      tunnels = {
        "b80518d1-9def-4a06-bd24-e2ec0a18b12d" = {
          credentialsFile = "${config.users.users.gaspard.home}/.cloudflared/b80518d1-9def-4a06-bd24-e2ec0a18b12d.json"; # "${config.sops.secrets."cloudflare/creds.json".path}";
          originRequest = {
            httpHostHeader = config.defaultConfigurationOptions.websiteHostName;
            noTLSVerify = true;
            originServerName = config.defaultConfigurationOptions.websiteHostName;
          };
          ingress = {
            "${config.defaultConfigurationOptions.websiteHostName}" = {
              service = "https://localhost:443";
            };
            "*.${config.defaultConfigurationOptions.websiteHostName}" = {
              service = "https://localhost:443";
            };
          };
          default = "http_status:404";
        };
      };
    };

    users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
      extraGroups = [ "users" ];
    };
    users.groups.cloudflared = { };
  };
}
