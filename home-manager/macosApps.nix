{ username, pkgs, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      skimpdf
      keycastr
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.dataspell
    ];
  };
}
