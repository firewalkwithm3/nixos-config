{ lib, ... }:
{
  virtualisation.oci-containers.containers = {
    wallos = {
      image = "bellamy/wallos:latest";
      ports = [ "8088:80" ];
      volumes = [
        "wallos-db:/var/www/html/db"
        "wallos-logos:/var/www/html/images/uploads/logos"
      ];
      extraOptions = [ "--pull=newer" ];
    };
  };

  services.caddy.virtualHosts."subscriptions.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:9000
      	  '';
  };
}
