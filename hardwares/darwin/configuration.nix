{
  pkgs,
  ...
}:
{
  system = {
    stateVersion = 5;
    primaryUser = "gen";
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        _HIHideMenuBar = true;
      };
      dock = {
        autohide = true;
      };
    };
  };
  users.users.gen.home = "/Users/gen";

  networking.hostName = "gen740";

  nix = {
    linux-builder = {
      enable = true;
      maxJobs = 4;
      ephemeral = true;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 256 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 4;
        };
      };
    };
    settings = {
      trusted-users = [
        "@admin"
      ];
    };
    optimise.automatic = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
}
