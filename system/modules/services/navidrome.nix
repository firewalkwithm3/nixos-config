{ config, lib, ... }:
{
  services.navidrome = {
    enable = true;
    settings.Address = "0.0.0.0";
    settings.port = 4533;
    settings.MusicFolder = "/mnt/volume2/media/beets";
    group = "media";
  };

  services.caddy.virtualHosts."music.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
	  extraConfig = ''
      route { crowdsec }
	    reverse_proxy 127.0.0.1:4533
	  '';
  };
}
