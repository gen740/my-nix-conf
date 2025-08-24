{ username, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home-manager = {
    users.${username} = import ./home.nix { inherit pkgs; };
  };
}
