{ pkgs, ... }: {
  imports = [
    ../base/configuration.nix
  ]
    
      # Add system packages

  environment.systemPackages = with pkgs; [

  ];
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
  # Enable nix-darwin system management
  services.nix-daemon.enable = true;
  


  # Configure system defaults
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
    };
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
  };

  # Auto upgrade nix package and the daemon service
  nix.package = pkgs.nix;
}
