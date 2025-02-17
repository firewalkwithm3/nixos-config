{
  config,
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix-rekey.packages.${pkgs.system}.default
    rage
    age-plugin-yubikey
  ];

  nix.settings.extra-sandbox-paths = [ "/tmp/agenix-rekey.${toString config.users.users.fern.uid}" ];

  age.rekey = {
    masterIdentities = [ ./yubikey.pub ];
    storageMode = "derivation";
    localStorageDir = ../../. + "/hosts/${config.networking.hostName}/secrets-rekeyed";
  };
}
