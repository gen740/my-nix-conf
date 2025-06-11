{
  description = "A flake package for the configuration of gen740";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    secrets = {
      url = "path:/opt/secrets";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
      home-manager,
      nix-darwin,
      nixos-hardware,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];

      flake = {
        mkHomeConfigurations =
          {
            username,
            pkgs,
            extraModules,
            ...
          }:
          home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs;
            modules = [
              ./home-manager/home.nix
              {
                home = {
                  username = username;
                };
              }
            ] ++ extraModules;
          };

        darwinConfigurations = {
          "gen740" = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              home-manager.darwinModules.home-manager
              ./home-manager
              ./home-manager/macosApps.nix
              ./hardwares/darwin/configuration.nix
            ];
            specialArgs = {
              username = "gen";
              inputs = inputs;
            };
          };
        };

        nixosConfigurations = {
          "nixos-t2mac" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              nixos-hardware.nixosModules.apple-t2
              ./hardwares/T2mac/configuration.nix
              home-manager.nixosModules.home-manager
              ./home-manager
            ];
            specialArgs = {
              inputs = inputs;
              username = "gen";
            };
          };

          "nixos-orbstack" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./hardwares/orbstack/configuration.nix
              home-manager.nixosModules.home-manager
              ./home-manager
            ];
            specialArgs = {
              inputs = inputs;
              username = "gen";
            };
          };
        };

      };

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          apps =
            let
              createSecretsIfNotExistsScript = pkgs.replaceVars ./scripts/check_and_create_secrets.sh {
                bash = "${pkgs.bash}/bin/bash";
                secrets_template = "${./scripts/secrets_template.nix}";
              };
            in
            {
              switchOrbstackConfiguration = {
                type = "app";
                program =
                  (pkgs.writeShellScriptBin "switch-orbstack-configuration" ''
                    sh ${createSecretsIfNotExistsScript}
                    exec sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch -v -L --show-trace --flake ${self.outPath}#nixos-orbstack
                  '').outPath
                  + "/bin/switch-orbstack-configuration";
              };

              switchT2MacConfiguration = {
                type = "app";
                program =
                  (pkgs.writeShellScriptBin "switch-t2mac-configuration" ''
                    sh ${createSecretsIfNotExistsScript}
                    exec sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch -v -L --show-trace --flake ${self.outPath}#nixos-t2mac
                  '').outPath
                  + "/bin/switch-t2mac-configuration";
              };

              switchDarwinConfiguration = {
                type = "app";
                program =
                  (pkgs.writeShellScriptBin "switch-darwin-configuration" ''
                    sh ${createSecretsIfNotExistsScript}
                    exec sudo ${
                      inputs.nix-darwin.packages.${system}.darwin-rebuild
                    }/bin/darwin-rebuild switch -v -L --show-trace --flake ${self.outPath}#gen740
                  '').outPath
                  + "/bin/switch-darwin-configuration";
              };
            };
        };
    };
}
