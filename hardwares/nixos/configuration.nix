{
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  users.users.gen = {
    uid = 501;
    extraGroups = [
      "wheel"
      "orbstack"
    ];

    # simulate isNormalUser, but with an arbitrary UID
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/gen";
    homeMode = "700";
    useDefaultShell = true;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = false;

  time.timeZone = "Asia/Tokyo";

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
