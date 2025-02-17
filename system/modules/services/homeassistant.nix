{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8123 ];

  virtualisation.oci-containers = {
    containers.homeassistant = {
      volumes = [
        "hass:/config"
      ];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        "--device=/dev/ttyUSB0:/dev/ttyUSB0"
        "--pull=newer"
      ];
    };

    containers.appdaemon = {
      volumes = [
        "appdaemon-config:/conf"
        "appdaemon-certs:/certs"
      ];
      image = "acockburn/appdaemon:latest";
      extraOptions = [
        "--network=host"
        "--pull=newer"
      ];
    };
  };

  services.caddy.virtualHosts."home.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:8123
      	  '';
  };
}
