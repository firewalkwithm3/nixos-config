{ config, lib, ... }:
{
  age.secrets.miniflux.rekeyFile = ../../../secrets/services/miniflux.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      BASE_URL = "https://rss.ferngarden.net";
      LISTEN_ADDR = "0.0.0.0:8083";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_REDIRECT_URL = "https://rss.ferngarden.net/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.fern.garden/application/o/miniflux/";
      OAUTH2_USER_CREATION = 1;
    };
  };

  services.caddy.virtualHosts."rss.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:8083
      	  '';
  };
}
