{ config, lib, pkgs, ... }:

{
  options.services.syncyomi = {
    enable = mkEnableOption "SyncYomi service";

    user = mkOption {
      type = types.str;
      default = "syncyomi";
      description = "User account under which SyncYomi runs";
    };

    group = mkOption {
      type = types.str;
      default = "syncyomi";
      description = "Group under which SyncYomi runs";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.syncyomi;
      description = "SyncYomi package to use";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/syncyomi";
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.syncyomi = {
      description = "SyncYomi service";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/syncyomi --config=/var/lib/syncyomi/.config/syncyomi";
        Restart = "on-failure";
      };
    };
  };
}
