{ config
, pkgs
, ...
}:

{
  config = {

    # Secrets management with sops-nix
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/secrets.yaml";
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    # This will automatically import SSH keys as age keys
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # This is using an age key that is expected to already be in the filesystem
    sops.age.keyFile = "/home/gaspard/.config/sops/age/keys.txt";
    # This will generate a new key if the key specified above does not exist
    sops.age.generateKey = true;

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
      authentik_env = {
        owner = "authentik";
        group = "authentik";
      };
      firefly_key_file = {
        owner = "firefly-iii";
      };
      "nixarr/wg_conf" = {
        owner = "nixarr";
        group = "nixarr";
      };

    };
  };
}
