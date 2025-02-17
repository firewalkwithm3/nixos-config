{ lib, config, ... }:
{
  services.jellyseerr = {
    enable = true;
    port = 5055;
  };

  services.caddy.virtualHosts."jellyseerr.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
            route { crowdsec }
      	    reverse_proxy 127.0.0.1:5055
      	  '';
  };
}
