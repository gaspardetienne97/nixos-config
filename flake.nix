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
    # Used to manage arr suite
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
    };
    # Used to manage authentik identity provider
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Used to deploy my personal website
    personal-website = {
      url = "github:gaspardetienne97/PersonalWebsite";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, catppuccin, home-manager, sops-nix, nixarr, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in
    {

      nixpkgs.overlays = [ (import ./overlays/freecad.nix) ];

      devShells.${system}.default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.mkShell { packages = with pkgs; [ nodejs ]; };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            pkgs-caddy = import inputs.nixpkgs-caddy { inherit system; };
            inherit inputs;
          };
          modules = [
            ./systems/homelab/configuration.nix

            catppuccin.nixosModules.catppuccin
            sops-nix.nixosModules.sops
            nixarr.nixosModules.default

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager. useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gaspard = {
                imports = [
                  ./systems/homelab/home.nix
                  catppuccin.homeManagerModules.catppuccin
                  sops-nix.homeManagerModules.sops
                ];
              };
            }

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
