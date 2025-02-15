{ config, lib, ... }:
{
  age.secrets.authentik = {
    rekeyFile = ../../../secrets/services/authentik.age;
    owner = "authentik";
    group = "authentik";
  };
  age.secrets.authentik-ldap = {
    rekeyFile = ../../../secrets/services/authentik-ldap.age;
    owner = "authentik";
    group = "authentik";
  };

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.authentik.path;
  };

  services.authentik-ldap = {
    enable = true;
    environmentFile = config.age.secrets.authentik-ldap.path;
  };

  services.caddy.virtualHosts."auth.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
	  extraConfig = ''
      route { crowdsec }
	    reverse_proxy 127.0.0.1:9000
	  '';
  };
}
