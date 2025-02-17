{ config, lib, ... }:
{
  age.secrets.qsticky.rekeyFile = ../../../secrets/services/qsticky.age;
  age.secrets.mam.rekeyFile = ../../../secrets/services/mam.age;

  virtualisation.oci-containers = {
    containers.qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      dependsOn = [ "gluetun" ];
      extraOptions = [
        "--network=container:gluetun"
        "--pull=newer"
      ];
      environment = {
        PUID = "1000";
        PGID = "1800";
        TZ = "Australia/Perth";
        WEBUI_PORT = "5001";
      };
      volumes = [
        "qbittorrent-config:/config"
        "qbittorrent-downloads:/downloads"
        "/mnt/volume1:/mnt/volume1"
        "/mnt/volume2:/mnt/volume2"
        "/mnt/volume3:/mnt/volume3"
      ];
    };
  };

  virtualisation.oci-containers = {
    containers.qsticky = {
      image = "ghcr.io/monstermuffin/qsticky:latest";
      environmentFiles = [ config.age.secrets.qsticky.path ];
      environment = {
        QBITTORRENT_HOST = "gluetun";
        QBITTORRENT_HTTPS = "false";
        QBITTORRENT_PORT = "5001";
        GLUETUN_HOST = "gluetun";
        GLUETUN_PORT = "8000";
        GLUETUN_AUTH_TYPE = "apikey";
        LOG_LEVEL = "INFO";
      };
      extraOptions = [ "--pull=newer" ];
    };
  };

  virtualisation.oci-containers = {
    containers.seedboxapi = {
      image = "myanonamouse/seedboxapi";
      environmentFiles = [ config.age.secrets.mam.path ];
      volumes = [ "seedboxapi:/config" ];
      dependsOn = [ "gluetun" ];
      extraOptions = [
        "--network=container:gluetun"
        "--pull=newer"
      ];
      environment = {
        DEBUG = "1";
        interval = "1";
      };
    };
  };

  services.caddy.virtualHosts."qbittorrent.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy http://127.0.0.1:5001
      	  '';
  };
}
