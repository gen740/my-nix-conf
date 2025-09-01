{
  description = "Modern Nix flake configuration for gen740's multi-platform setup";

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
    nixos-hardware.url = "github:mkorje/nixos-hardware";
    secrets.url = "path:./scripts/secrets_template";
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      flake = {
        darwinConfigurations = {
          gen740 = nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              home-manager.darwinModules.home-manager
              ./home-manager
              ./hardwares/darwin/configuration.nix
            ];
            specialArgs = {
              username = "gen";
            };
          };
        };
        nixosConfigurations = {
          t2mac = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              ./home-manager
              inputs.nixos-hardware.nixosModules.apple-t2
              ./hardwares/T2mac/configuration.nix
            ];
            specialArgs = {
              username = "gen";
              inherit inputs;
            };
          };
          orbstack = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              ./home-manager
              ./hardwares/orbstack/configuration.nix
            ];
            specialArgs = {
              username = "gen";
            };
          };
        };
      };

      perSystem =
        { pkgs, system, ... }:
        let
          setupSecrets = pkgs.replaceVars ./scripts/check_and_create_secrets.sh {
            bash = "${pkgs.bash}/bin/bash";
            secrets_template = "${./scripts/secrets_template/flake.nix}";
          };

          mkSwitchApp =
            {
              name,
              command,
              flakeTarget,
              description,
            }:
            {
              type = "app";
              program = "${pkgs.writeShellScript "switch-${name}" ''
                set -euo pipefail
                echo "Setting up secrets..."
                sh ${setupSecrets}
                echo "Switching to ${flakeTarget}..."
                exec sudo ${command} --override-input secrets "path:$HOME/.config/nix-secrets" \
                  switch -v -L --show-trace --flake .#${flakeTarget}
              ''}";
              meta.description = description;
            };
        in
        {
          apps = {
            armmac =
              if pkgs.stdenv.isDarwin then
                mkSwitchApp {
                  name = "darwin";
                  command = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
                  flakeTarget = "gen740";
                  description = "Switch to Darwin (macOS) configuration";
                }
              else
                {
                  type = "app";
                  program = "${pkgs.writeShellScript "switch-darwin-noop" ''
                    echo "This is not a Darwin system. The 'armmac' app is a no-op."
                  ''}";
                  meta.description = "No-op on non-Darwin systems";
                };

            t2mac =
              if pkgs.stdenv.isLinux then
                mkSwitchApp {
                  name = "t2mac";
                  command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
                  flakeTarget = "t2mac";
                  description = "Switch to NixOS configuration for Apple T2 Mac";
                }
              else
                {
                  type = "app";
                  program = "${pkgs.writeShellScript "switch-t2mac-noop" ''
                    echo "This is not a Linux system. The 't2mac' app is a no-op."
                  ''}";
                  meta.description = "No-op on non-Linux systems";
                };

            orbstack =
              if pkgs.stdenv.isLinux then
                mkSwitchApp {
                  name = "orbstack";
                  command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
                  flakeTarget = "orbstack";
                  description = "Switch to NixOS configuration for OrbStack container";
                }
              else
                {
                  type = "app";
                  program = "${pkgs.writeShellScript "switch-orbstack-noop" ''
                    echo "This is not a Linux system. The 'orbstack' app is a no-op."
                  ''}";
                  meta.description = "No-op on non-Linux systems";
                };
          };
        };
    };
}
