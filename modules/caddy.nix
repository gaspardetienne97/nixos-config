# Caddy is a reverse proxy, like Nginx or Traefik. This creates an ingress
# point from my local network or the public (via Cloudflare). Instead of a
# Caddyfile, I'm using the more expressive JSON config file format. This means
# I can source routes from other areas in my config and build the JSON file
# using the result of the expression.

# Caddy helpfully provides automatic ACME cert generation and management, but
# it requires a form of validation. We are using a custom build of Caddy
# (compiled with an overlay) to insert a plugin for managing DNS validation
# with Cloudflare's DNS API.

{
  config,
  # pkgs-caddy,
  ...
}:
# let

# cloudflareIpRanges = [

#    # Cloudflare IPv4: https://www.cloudflare.com/ips-v4
#    "173.245.48.0/20"
#    "103.21.244.0/22"
#    "103.22.200.0/22"
#    "103.31.4.0/22"
#    "141.101.64.0/18"
#    "108.162.192.0/18"
#    "190.93.240.0/20"
#    "188.114.96.0/20"
#    "197.234.240.0/22"
#    "198.41.128.0/17"
#    "162.158.0.0/15"
#    "104.16.0.0/13"
#    "104.24.0.0/14"
#    "172.64.0.0/13"
#    "131.0.72.0/22"

#    # Cloudflare IPv6: https://www.cloudflare.com/ips-v6
#    "2400:cb00::/32"
#    "2606:4700::/32"
#    "2803:f800::/32"
#    "2405:b500::/32"
#    "2405:8100::/32"
#    "2a06:98c0::/29"
#    "2c0f:f248::/32"

#  ];

# in
{

  config = {
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
