{ lib, ... }:
{
  services.esphome = {
    enable = true;
    address = "127.0.0.1";
    port = 6052;
  };

  services.caddy.virtualHosts."esphome.ferngarden.net" = {
	  logFormat = lib.mkForce ''
	    output discard
	  '';
	  extraConfig = ''
      route { crowdsec }
	    reverse_proxy 127.0.0.1:6052
	  '';
  };
}
