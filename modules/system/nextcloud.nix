# Nextcloud Server Module
# Self-hosted cloud storage and collaboration platform
# Features:
# - File sync and sharing
# - Integrated office suite (OnlyOffice)
# - Calendar, contacts, and task management
# - PostgreSQL database backend
# - Redis caching for improved performance
{ config, lib, pkgs, ... }:

{
  options.modules.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud server";
  };

  config = lib.mkIf config.modules.nextcloud.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "gaspardetienne.com";
      autoUpdateApps.startAt = "05:00:00";
      datadir = "/vault/datastorage/nextcloud-data";
      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "50G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit
          calendar
          contacts
          mail
          notes
          onlyoffice
          tasks
          ;
      };

      config = {
        dbtype = "pgsql";
        dbuser = config.users.users.nextcloud.name;
        dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
        dbname = config.users.users.nextcloud.name;
        adminpassFile = config.sops.secrets."nextcloud/admin_pass".path;
        adminuser = "root";
      };
      settings =
        let
          protocol = "https";
          dir = "/nextcloud";
          host = "127.0.0.1";
        in
        {
          trusted_proxies = [ "127.0.0.1" ];
          trusted_domains = [ "/cloud" ];
          overwriteprotocol = protocol;
          overwritehost = host;
          overwritewebroot = dir;
          overwrite.cli.url = "${protocol}://${host}${dir}/";
          htaccess.RewriteBase = dir;
          default_phone_region = "US";
          mail_smtpmode = "sendmail";
          mail_sendmailmode = "pipe";
        };
      # nginx.enableFastcgiRequestBuffering = true;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ config.users.users.nextcloud.name ];
      ensureUsers = [
        {
          name = config.users.users.nextcloud.name;
          ensureDBOwnership = true;
        }
      ];
    };

    services.onlyoffice = {
      enable = true;
      hostname = "/office";
      #services.onlyoffice.jwtSecretFile =config.sops.
    };
    # services.nginx.enable = false;
    users.users.nginx.isSystemUser = true;
    users.users.nginx.group = "nginx";
    users.groups.nginx = { };

    services.phpfpm.pools.nextcloud.settings = {
      "listen.owner" = config.services.caddy.user;
      "listen.group" = config.services.caddy.group;
    };
    users.users.caddy.extraGroups = [ config.users.users.nextcloud.name ];
    users.users.gaspard.extraGroups = [ config.users.users.nextcloud.name ];

    # ensure that postgres is running *before* running the setup
    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
    # Open to groups, allowing for backups
    systemd.services.phpfpm-nextcloud.serviceConfig.StateDirectoryMode = "0770";

    # Log metrics to prometheus
    /*
      networking.hosts."127.0.0.1" = [ config.hostnames.content ];
      services.prometheus.exporters.nextcloud = {
        enable = config.prometheus.exporters.enable;
        username = config.services.nextcloud.config.adminuser;
        url = "https://${config.hostnames.content}";
        passwordFile = config.services.nextcloud.config.adminpassFile;
      };
      prometheus.scrapeTargets = [
        "127.0.0.1:${
          builtins.toString config.services.prometheus.exporters.nextcloud.port
        }"
      ];
    */
    # Allows nextcloud-exporter to read passwordFile
    # users.users.nextcloud-exporter.extraGroups = [ "nextcloud" ];

  };
}
