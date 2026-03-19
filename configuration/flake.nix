{
    description = "Config by thron";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
    };

    outputs = { self, nixpkgs, home-manager, nur, ...}: {
        nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                { nixpkgs.overlays = [ nur.overlays.default ]; }
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.thron = import ./home.nix;
                        backupFileExtension = "backup";
                    };
                }
            ];
        };
    };

}