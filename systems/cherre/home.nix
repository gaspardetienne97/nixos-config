{ pkgs, config, ... }:
let
  basePackages = (import ../base/home.nix { inherit config pkgs; }).home.packages;
in
{
  imports = [
    ../base/home.nix
  ];
  modules = {
    # alacritty.enable = true;


    # Common packages that don't need specific configuration
    home.packages = basePackages ++ (with pkgs; [
      k9s
      dbeaver-bin
      spotify
      slack
      google-cloud-sdk
      kubernetes-helm
    ]);

  }
