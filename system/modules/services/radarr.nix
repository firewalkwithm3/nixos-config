{ lib, ... }:
{
  services.radarr = {
    enable = true;
    group = "media";
  };

  virtualisation.oci-containers = {
    containers.radarr-letterboxd = {
      environment.REDIS_URL = "redis://radarr-letterboxd-redis:6379";
      image = "screeny05/letterboxd-list-radarr:latest";
      ports = [ "5000:5000" ];
      extraOptions = [ "--pull=newer" ];
    };

    containers.radarr-letterboxd-redis = {
      image = "redis:6.0";
      extraOptions = [ "--pull=newer" ];
    };
  };

  services.caddy.virtualHosts."radarr.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:9000
      	  '';
  };
}
