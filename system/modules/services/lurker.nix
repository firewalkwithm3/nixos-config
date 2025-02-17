{ lib, ... }:
{
  services.lurker = {
    enable = true;
    port = 9495;
  };

  services.caddy.virtualHosts."lurker.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:9495
      	  '';
  };
}
