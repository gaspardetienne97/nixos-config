{ pkgs, config, ... }:

{
 imports = [../base/home.nix 
 ];
   # Common packages that don't need specific configuration
  home.packages = with pkgs; [
    k9s
    dbeaver-bin
spotify
    slack
    google-cloud-sdk
  ];

}
