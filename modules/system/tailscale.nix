# Tailscale VPN Module
# Enables secure mesh networking between devices
# Provides:
# - Zero-config VPN functionality
# - Secure access to services across devices
# - NAT traversal capabilities
{ config, lib, ... }:

{
  options.modules.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = lib.mkIf config.modules.tailscale.enable {
    # Enable Tailscale
    services.tailscale.enable = true;
  };
}
