{
  description = "A secrets template for gen740";

  outputs =
    { ... }:
    {
      secrets = {
        openssh.authorizedKeys.keys = [ ];
        services.gitlab.databasePasswordFile = "placeholder-db-password";
        services.gitlab.initialRootPassword = "placeholder-root-password";
        services.gitlab.secrets.secret = "placeholder-secret-32-chars-long!!!";
        services.gitlab.secrets.otpsecret = "placeholder-otp-secret-32-chars!!";
        services.gitlab.secrets.dbsecret = "placeholder-db-secret-32-chars!!!";
        services.gitlab.secrets.activeRecordPrimaryKeyFile = "placeholder-active-record-primary-key";
        services.gitlab.secrets.activeRecordDeterministicKeyFile = "placeholder-active-record-deterministic-key";
        services.gitlab.secrets.activeRecordSaltFile = "placeholder-active-record-salt";
      };
    };
}
