# Base configuration module that should be imported by all hosts
# Provides common system settings and essential packages
{ config, lib, pkgs, ... }:

{
  {
   imports = 
    # Import all .nix files from modules directory
    let
      modulesDir = ../../modules/system;
      moduleFiles = builtins.filter
        (name: builtins.match ".*\\.nix" name != null)
        (builtins.attrNames (builtins.readDir modulesDir));
    in
    (map (file: modulesDir + "/${file}") moduleFiles)
  
    # Essential system packages that should be available on all systems
    # These are utilities that are commonly needed for basic system administration
    environment.systemPackages = with pkgs; [
      git    # Version control
      curl   # URL data transfer tool
      wget   # File download utility
    ];

    # System localization and timezone settings
    # These can be overridden in specific host configurations
    time.timeZone = lib.mkDefault "UTC";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    # Core system configuration
    system = {
      # NixOS release version - should be updated when upgrading
      stateVersion = lib.mkDefault "23.05";
      
      # Enable automatic system upgrades
      # Can be disabled per-host if needed
      autoUpgrade.enable = lib.mkDefault true;
    };
}
