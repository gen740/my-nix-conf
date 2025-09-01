{
  description = "A secrets template for gen740";

  outputs =
    { ... }:
    {
      secrets = {
        openssh.authorizedKeys.keys = [ ];
      };
    };
}
