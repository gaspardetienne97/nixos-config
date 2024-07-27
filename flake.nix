{
description = "My nix flake config";
inputs = {
nixpkgs.url = "nixpkgs/nixos-unstable";
catppuccin.url = "github:catppuccin/nix";
home-manager ={ 
url = "github:nix-community/home-manager/master";
inputs.nixpkgs.follows = "nixpkgs";
};

};

outputs = inputs@{self, nixpkgs, catppuccin ,home-manager, ...}:
let 
lib = nixpkgs.lib;
system = "x86_64-linux";
pkgs = nixpkgs.legacyPackages.${system};
in {
 # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;
nixosConfigurations = {
nixos = lib.nixosSystem {
inherit system;
modules = [./configuration.nix
 # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;


            home-manager.users.gaspard = {
            imports = [ ./home.nix catppuccin.homeManagerModules.catppuccin];
            };

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
];
};
};
};
}
