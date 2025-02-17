{ config, lib, ... }:
{
  age.secrets.invidious = {
    rekeyFile = ../../../secrets/services/invidious.age;
    owner = "65186";
    group = "65186";
  };

  services.invidious = {
    enable = true;
    address = "0.0.0.0";
    port = 3002;
    domain = "invidious.ferngarden.net";
    settings = {
      registration_enabled = false;
    };
    extraSettingsFile = config.age.secrets.invidious.path;
    sig-helper.enable = true;
  };

  services.caddy.virtualHosts."invidious.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:3002
      	  '';
  };
}
