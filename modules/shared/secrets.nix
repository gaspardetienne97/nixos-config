{ config
, pkgs
, inputs
, ...
}:

{
  config = {

    # Secrets management with sops-nix
    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = "/home/gaspard/.config/sops/age/keys.txt";

    sops.secrets = {
      "nextcloud/admin_pass" = {
        owner = "nextcloud";
        group = "nextcloud";
      };
      "cloudflare/api_token" = {
        owner = "caddy";
        group = "caddy";
      };
      "cloudflare/creds.json" = {
        owner = "cloudflared";
        group = "cloudflared";
      };
      authentik-env = { };

    };
  };
}
