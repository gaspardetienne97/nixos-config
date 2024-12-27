{ config, pkgs, ... }:

{
  # Networking settings
  networking = {
    # Enable DHCP client
    dhcpcd.enable = true;

    # Firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ]; # Allow SSH, HTTP, and HTTPS
      allowedUDPPorts = [];
        logRefusedConnections = true;

    };
  };
}
