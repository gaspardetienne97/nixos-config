# Caddy is a reverse proxy, like Nginx or Traefik. This creates an ingress
# point from my local network or the public (via Cloudflare). Instead of a
# Caddyfile, I'm using the more expressive JSON config file format. This means
# I can source routes from other areas in my config and build the JSON file
# using the result of the expression.

# Caddy helpfully provides automatic ACME cert generation and management, but
# it requires a form of validation. We are using a custom build of Caddy
# (compiled with an overlay) to insert a plugin for managing DNS validation
# with Cloudflare's DNS API.

# Caddy web server module
# Provides reverse proxy functionality with automatic HTTPS certificate management
# Features:
# - Automatic HTTPS with Let's Encrypt
# - Reverse proxy configuration
# - Integration with Cloudflare for DNS validation
# - Security headers and access control
{ config, lib, pkgs, ... }:

{
  options.modules.caddy = {
    enable = lib.mkEnableOption "Caddy web server";
  };

  config = lib.mkIf config.modules.caddy.enable {
    environment.systemPackages = [ pkgs.caddy ];

    users.users.caddy.isSystemUser = true;
    users.users.caddy.group = "caddy";
    users.groups.caddy = { };

    services.caddy = {
      enable = true;
      # Forces Caddy to error if coming from a non-Cloudflare IP
      #      cidrAllowlist = cloudflareIpRanges;

      # # Tell Caddy to use Cloudflare DNS for ACME challenge validation
      # package = pkgs-caddy.caddy.override {
      #   externalPlugins = [
      #     {
      #       name = "cloudflare";
      #       repo = "github.com/caddy-dns/cloudflare";
      #       version = "master";
      #     }
      #   ];
      #   vendorHash = "sha256-YRsPu+rTu9HEQQlj4dK2BH8DNGHo//VL5zhoU0hz7DI=";
      # };
      virtualHosts."localhost".extraConfig = ''
        respond "Hi Gaspard!"
      '';
      virtualHosts."gaspardetienne.com".extraConfig = ''
        reverse_proxy 0.0.0.0:3000
      '';
    };

    # Allows Nextcloud to trust Cloudflare IPs
    # services.nextcloud.extraOptions.trusted_proxies = cloudflareIpRanges;

    # Allows Caddy to serve lower ports (443, 80)
    systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";

    # Required for web traffic to reach this machine
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    # HTTP/3 QUIC uses UDP (not sure if being used)
    # networking.firewall.allowedUDPPorts = [ 443 ];

    # Caddy exposes Prometheus metrics with the admin API
    # https://caddyserver.com/docs/api
    # prometheus.scrapeTargets = [ "127.0.0.1:2019" ];

  };
}
