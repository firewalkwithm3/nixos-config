{ lib, config, ... }:
{
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 8081;
    group = "media";
  };

  services.caddy.virtualHosts."audiobooks.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
            route { crowdsec }
      	    reverse_proxy 127.0.0.1:8081
      	  '';
  };
}
