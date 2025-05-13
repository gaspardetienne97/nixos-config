# Authentik Module

{ config
, lib
, pkgs
, authentik-nix
, ...
}:

{
  imports = [
    authentik-nix.nixosModules.default
  ];

  options.modules.authentik = {
    enable = lib.mkEnableOption "authentik service";
  };

  config = lib.mkIf config.modules.authentik.enable {
    services.authentik = {
      enable = true;
      # The environmentFile needs to be on the target host!
      # Best use something like sops-nix or agenix to manage it
      environmentFile = config.sops.secrets.authentik_env.path;

      settings = {
        email = {
          host = "localhost";
          port = 587;
          username = "mail@gaspardetienne.com";
          use_tls = true;
          use_ssl = false;
          from = "mail@gaspardetienne.com";
        };
        disable_startup_analytics = true;
        avatars = "initials";
      };
    };
  };
}
