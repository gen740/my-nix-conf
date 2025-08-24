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
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    secrets = {
      url = "path:/Users/gen/.config/nix-secrets";
    };
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
              ./home-manager/macosApps.nix
            ];
            specialArgs = {
              username = "gen";
            };
          };
        };
        nixosConfigurations = {
          nixos-t2mac = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              ./home-manager
              inputs.nixos-hardware.nixosModules.apple-t2
              ./hardwares/T2mac/configuration.nix
            ];
            specialArgs = {
              username = "gen";
            };
          };
          nixos-orbstack = nixpkgs.lib.nixosSystem {
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
            secrets_template = "${./scripts/secrets_template.nix}";
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
                exec sudo ${command} switch -v -L --show-trace --flake .#${flakeTarget}
              ''}";
              meta.description = description;
            };
        in
        {
          apps = {
            switchDarwinConfiguration = mkSwitchApp {
              name = "darwin";
              command = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
              flakeTarget = "gen740";
              description = "Switch to Darwin (macOS) configuration";
            };

            switchT2MacConfiguration = mkSwitchApp {
              name = "t2mac";
              command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              flakeTarget = "nixos-t2mac";
              description = "Switch to NixOS configuration for Apple T2 Mac";
            };

            switchOrbstackConfiguration = mkSwitchApp {
              name = "orbstack";
              command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              flakeTarget = "nixos-orbstack";
              description = "Switch to NixOS configuration for OrbStack container";
            };

            default = mkSwitchApp {
              name = "default";
              command =
                if pkgs.stdenv.isDarwin then
                  "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild"
                else
                  "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              flakeTarget = if pkgs.stdenv.isDarwin then "gen740" else "nixos-orbstack";
              description = "Switch to platform-appropriate configuration (Darwin or OrbStack)";
            };
          };

          devShells.default = pkgs.mkShell {
            name = "nix-config";
            packages = with pkgs; [
              nixd
              nixfmt
            ];
          };
        };
    };
}
