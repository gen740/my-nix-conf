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
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];

      flake =
        let
          # Common configuration values
          username = "gen";

          # Common specialArgs for all configurations
          commonSpecialArgs = {
            inherit inputs username;
          };

          # Helper function to create system configurations
          mkSystem =
            {
              system,
              modules,
              specialArgs ? { },
            }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              modules = modules ++ [
                inputs.home-manager.nixosModules.home-manager
                ./home-manager
              ];
              specialArgs = commonSpecialArgs // specialArgs;
            };

          # Helper function to create darwin configuration
          mkDarwin =
            {
              system,
              modules,
              specialArgs ? { },
            }:
            inputs.nix-darwin.lib.darwinSystem {
              inherit system;
              modules = modules ++ [
                inputs.home-manager.darwinModules.home-manager
                ./home-manager
              ];
              specialArgs = commonSpecialArgs // specialArgs;
            };
        in
        {
          darwinConfigurations = {
            gen740 = mkDarwin {
              system = "aarch64-darwin";
              modules = [
                ./hardwares/darwin/configuration.nix
                ./home-manager/macosApps.nix
              ];
            };
          };

          nixosConfigurations = {
            nixos-t2mac = mkSystem {
              system = "aarch64-linux";
              modules = [
                inputs.nixos-hardware.nixosModules.apple-t2
                ./hardwares/T2mac/configuration.nix
              ];
            };

            nixos-orbstack = mkSystem {
              system = "aarch64-linux";
              modules = [
                ./hardwares/orbstack/configuration.nix
              ];
            };
          };
        };

      perSystem =
        { pkgs, system, ... }:
        let
          # Common script for secrets setup
          setupSecrets = pkgs.replaceVars ./scripts/check_and_create_secrets.sh {
            bash = "${pkgs.bash}/bin/bash";
            secrets_template = "${./scripts/secrets_template.nix}";
          };

          # Helper to create switch apps
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
              command = "${inputs.nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
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

            # Default app
            default = mkSwitchApp {
              name = "default";
              command =
                if pkgs.stdenv.isDarwin then
                  "${inputs.nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild"
                else
                  "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              flakeTarget = if pkgs.stdenv.isDarwin then "gen740" else "nixos-orbstack";
              description = "Switch to platform-appropriate configuration (Darwin or OrbStack)";
            };
          };

          # Development shell
          devShells.default = pkgs.mkShell {
            name = "nix-config";
            packages = with pkgs; [
              nixd
              nixfmt-rfc-style
              nil
              nix-output-monitor
            ];
          };
        };
    };
}
