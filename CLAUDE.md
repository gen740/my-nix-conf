# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### System Configuration Management
```bash
# Apply Darwin (macOS) configuration
nix run .#switchDarwinConfiguration

# Apply NixOS configuration for T2 Mac
nix run .#switchT2MacConfiguration

# Apply NixOS configuration for OrbStack container
nix run .#switchOrbstackConfiguration
```

### Development Workflow
```bash
# Update flake inputs
nix flake update

# Check flake configuration
nix flake check

# Build specific configuration without applying
nix build .#darwinConfigurations.gen740.system
nix build .#nixosConfigurations.nixos-t2mac.config.system.build.toplevel

# Enter development shell with formatting tools
nix develop

# Format Nix files
nixfmt flake.nix

# Use default switch command (auto-detects platform)
nix run .#default
```

## Architecture Overview

This is a multi-platform Nix configuration repository managing:
- **macOS systems** via nix-darwin
- **NixOS systems** including Apple T2 hardware support
- **Container environments** via OrbStack
- **Home Manager** for user environment across all platforms

### Key Components

**Flake Structure (`flake.nix:23-156`)**
- Uses flake-parts for modular organization
- Defines three main system configurations: Darwin, T2Mac, and OrbStack
- Includes automated setup scripts for secrets management

**Home Manager Configuration (`home-manager/home.nix`)**
- Centralized user environment with shell aliases, packages, and dotfiles
- Integrates Neovim, tmux, git, zsh, and development tools
- Modular structure with separate files for each application

**Hardware-Specific Configurations**
- `hardwares/darwin/`: macOS-specific settings with nix-darwin
- `hardwares/T2mac/`: NixOS for Apple T2 hardware with custom firmware
- `hardwares/orbstack/`: Container-specific NixOS configuration

**Secrets Management**
- External secrets flake at `/opt/secrets`
- Automated creation via `scripts/check_and_create_secrets.sh`
- Used for SSH keys, service passwords, and certificates

### Multi-Platform Support

The configuration supports three distinct environments:
1. **Darwin (gen740)**: Primary macOS workstation with development tools
2. **T2Mac**: Full NixOS server with GitLab, Samba, NFS, and remote access
3. **OrbStack**: Lightweight container environment for development

Each platform shares the same Home Manager configuration but has platform-specific system settings and services.

### Development Tools Integration

- **Neovim**: Custom configuration in `home-manager/nvim/`
- **Terminal**: Alacritty with custom themes and keybindings
- **Git**: Configured with GitHub CLI and extensions
- **Shell**: Zsh with custom aliases and integrations
- **Development**: Includes `claude-code`, `gemini-cli`, and various CLI tools