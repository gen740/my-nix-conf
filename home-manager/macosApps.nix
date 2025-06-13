{ username, pkgs, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      skimpdf
      keycastr
      utm
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.dataspell
    ];
  };
}
