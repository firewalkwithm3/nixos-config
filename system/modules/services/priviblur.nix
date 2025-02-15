{ lib, ... }:
{
  virtualisation.oci-containers.containers = {
    priviblur = {
      image = "quay.io/syeopite/priviblur:latest";
      ports = [ "8084:8000" ];
      volumes = [
        "priviblur:/priviblur"
      ];
      extraOptions = [ "--pull=newer" ];
    };
  };

  services.caddy.virtualHosts."priviblur.ferngarden.net" = {
	  logFormat = lib.mkForce ''
	    output discard
	  '';
	  extraConfig = ''
	    reverse_proxy 127.0.0.1:9000
	  '';
  };
}
