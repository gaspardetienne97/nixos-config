{
  description = "My nix flake config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
# used for macOS configuration
  darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Used for home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
# Used for sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Used for caddy plugins
    nixpkgs-caddy.url = "github:jpds/nixpkgs/caddy-external-plugins";
  };

  outputs = inputs@{ self, nixpkgs, darwin, catppuccin, home-manager, sops-nix, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
    in
    {

      nixpkgs.overlays = [ (import ./overlays/freecad.nix) ];

      devShells."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
        in

        pkgs.mkShell { packages = with pkgs; [ nodejs ]; };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            pkgs-caddy = import inputs.nixpkgs-caddy { inherit system; };
          };
          modules = [
            ./systems/homelab/configuration.nix
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gaspard = {
                imports = [
                  .systems/homelab/home.nix
                  catppuccin.homeManagerModules.catppuccin
                  sops-nix.homeManagerModules.sops
                ];
              };
            }

            sops-nix.nixosModules.sops
          ];
        };
      };

      # make darwin as a module of nixos
         darwinConfigurations = {
        Gaspards-MacBook-Pro = darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [
            ./systems/cherre/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gaspard = {
                imports = [
                  ./systems/cherre/home.nix
                  catppuccin.homeManagerModules.catppuccin
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };
    };
}
