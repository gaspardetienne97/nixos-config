# $ cloudflared tunnel route dns <UUID or NAME> gaspardetienne.com
{ config, ... }:
let
  hostName = config.personalConfig.websiteHostName;
  tunnelID = "b80518d1-9def-4a06-bd24-e2ec0a18b12d";
in
{
  services.cloudflared = {
    user = config.personalConfig.username;
    enable = true;
    tunnels = {
      "${tunnelID}" = {
        credentialsFile = "${config.users.users.gaspard.home}/.cloudflared/${tunnelID}.json"; # "${config.sops.secrets."cloudflare/creds.json".path}";
        originRequest = {
          httpHostHeader = hostName;
          noTLSVerify = true;
          originServerName = hostName;
        };
        ingress = {
          "${hostName}" = {
            service = "https://localhost:443";
          };
          "*.${hostName}" = {
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
}
