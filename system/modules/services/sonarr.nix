{ lib, ... }:
{
  services.sonarr = {
    enable = true;
    group = "media";
  };

  services.caddy.virtualHosts."sonarr.ferngarden.net" = { 
	  logFormat = lib.mkForce ''
	    output discard
	  '';
	  extraConfig = ''
	    reverse_proxy 127.0.0.1:9000
	  '';
  };
}
