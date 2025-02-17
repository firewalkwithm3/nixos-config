{ lib, ... }:
{
  services.bazarr = {
    enable = true;
    listenPort = 6767;
    group = "media";
  };

  services.caddy.virtualHosts."bazarr.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:9000
      	  '';
  };
}
