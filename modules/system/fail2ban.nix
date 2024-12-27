# Fail2ban Security Module
# Provides intrusion prevention by blocking suspicious IPs
# Features:
# - Caddy server log monitoring
# - Customizable ban times and retry limits
# - HTTP/HTTPS port protection
{ config, lib, ... }:

{
  options.modules.fail2ban = {
    enable = lib.mkEnableOption "Fail2ban intrusion prevention";
  };

  config = lib.mkIf config.modules.fail2ban.enable {
    services.fail2ban = {
      enable = true;
      jails = {
        caddy = ''
          enabled = true
          port = 80,443
          filter = caddy-auth
          logpath = /var/log/caddy/access.log
          maxretry = 5
          findtime = 1h
          bantime = 24h
        '';
      };
    };
  };
}