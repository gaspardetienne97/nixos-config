{ config
, lib
, pkgs
, personal-website
, ...
}:
{
  options.modules.personal-website = {
    enable = lib.mkEnableOption "Personal Website Service";
  };

  config = lib.mkIf config.modules.personal-website.enable {
    systemd.services.personal-website = {
      description = "Personal Website Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.nodejs_22} --envfile=.env ${personal-website}/bin";
        Restart = "always";
        User = "personal-website";
        Group = "personal-website";
      };

      environment = {
        PORT = "3000";
        NODE_ENV = "production";
      };
    };

    users.users.personal-website = {
      isSystemUser = true;
      group = "personal-website";
      description = "Personal website service user";
    };

    users.groups.personal-website = { };
  };
}
