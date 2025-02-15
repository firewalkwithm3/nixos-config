{ inputs, pkgs, lib, ... }:
{
  services.prowlarr = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.prowlarr;
  };

  virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [ "8191:8191" ];
      extraOptions = [ "--pull=newer" ];
    };
  };

  services.caddy.virtualHosts."prowlarr.ferngarden.net" = {
	  logFormat = lib.mkForce ''
	    output discard
	  '';
	  extraConfig = ''
	    reverse_proxy 127.0.0.1:9000
	  '';
  };
}
