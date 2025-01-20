{ pkgs
, lib
, inputs
, config
, ...
}: {
  imports = [ inputs.nixarr.nixosModules.default ];

  options.modules.nixarr = {
    enable = lib.mkEnableOption "Arr Suite configuration";
  };

  config = lib.mkIf config.modules.nixarr.enable {



    #disable useradd and passwd.
    #users.mutableUsers = false;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.nixarr = {
      isSystemUser = true;
      description = "Nixarr user";
    };

    services.jellyfin.group = "nixarr";
    services.jellyfin.user = "nixarr";


    # Create videos directory, allow anyone in Jellyfin group to manage it
    systemd.tmpfiles.rules = [
      "d /var/lib/jellyfin 0775 jellyfin media"
      "d /var/lib/jellyfin/library 0775 jellyfin media"
    ];

    # Enable VA-API for hardware transcoding
    hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [ pkgs.libva ];
    };

    environment.systemPackages = [ pkgs.libva-utils ];
    environment.variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      "VDPAU_DRIVER" = "radeonsi";
      "LIBVA_DRIVER_NAME" = "radeonsi";
    };
    users.users.nixarr.extraGroups =
      [ "render" "video" ]; # Access to /dev/dri

    # Fix issue where Jellyfin-created directories don't allow access for media group
    #systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";

    # Requires MetricsEnable is true in /var/lib/jellyfin/config/system.xml
    # prometheus.scrapeTargets = [ "127.0.0.1:8096" ];


    nixarr = {
      enable = true;
      # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
      mediaDir = "/data/media";
      stateDir = "/data/media/.state/nixarr";

      mediaUsers = [ "nixarr" ];

      jellyfin = {
        enable = true;
        openFirewall = true;
        # These options set up a nginx HTTPS reverse proxy, so you can access
        # Jellyfin on your domain with HTTPS
        # expose.https = {
        #   enable = true;
        #   domainName = "your.domain.com";
        #   acmeMail = "your@email.com"; # Required for ACME-bot
        # };
      };

      transmission = {
        enable = true;
        openFirewall = true;
        vpn.enable = true;
        # peerPort = 50000; # Set this to the port forwarded by your VPN
      };

      # It is possible for this module to run the *Arrs through a VPN, but it
      # is generally not recommended, as it can cause rate-limiting issues.
      bazarr = {
        enable = true;
        openFirewall = true;
      };
      lidarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      radarr = {
        enable = true;
        openFirewall = true;
      };
      readarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
    };

    services.jellyseerr = {
      enable = true;
      openFirewall = true;
    };
  };
}
