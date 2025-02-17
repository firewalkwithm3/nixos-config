{ config, lib, ... }:

{
  age.secrets.vaultwarden = {
    rekeyFile = ../../../secrets/services/vaultwarden.age;
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      DOMAIN = "https://vault.ferngarden.net";
      WEBSOCKET_ENABLED = true;
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      DATABASE_URL = "postgresql:///vaultwarden";
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8087;
    };
    environmentFile = config.age.secrets.vaultwarden.path;
  };

  services.caddy.virtualHosts."vault.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:8087
      	  '';
  };
}
