{ lib, ... }:
{
  services.immich = {
    enable = true;
    redis.enable = true;
    machine-learning.enable = true;
    host = "0.0.0.0";
    port = 3001;
  };

  services.caddy.virtualHosts."photos.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:3001
      	  '';
  };
}
