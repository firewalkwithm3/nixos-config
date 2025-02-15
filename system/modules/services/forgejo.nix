{ config, lib, ... }:
{
  services.forgejo = {
    enable = true;
    database = {
      type = "postgres";
      socket = "/var/run/postgresql";
    };
    settings.DEFAULT = {
      APP_NAME = "Fern's Git Server";
      RUN_MODE = "prod";
    };
    settings.server = {
      DOMAIN = "git.fern.garden";
      HTTP_ADDR = "0.0.0.0";
      HTTP_PORT = 3000;
      ROOT_URL = "https://git.fern.garden";
    };
    settings.service.DISABLE_REGISTRATION = true;
  };

  services.caddy.virtualHosts."git.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
      route { crowdsec }
      reverse_proxy 127.0.0.1:3000
    '';
  };
}
