{ config, lib, ... }:
{
  age.secrets = {
    matrix = {
      rekeyFile = ../../../secrets/services/matrix.age;
      owner = "matrix-synapse";
      group = "matrix-synapse";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8448 ];

  services.matrix-synapse = {
    enable = true;
    configureRedisLocally = true;
    extras = [
      "oidc"
      "systemd"
      "postgres"
      "redis"
      "url-preview"
      "user-search"
    ];
    extraConfigFiles = [ config.age.secrets.matrix.path ];
    settings = {
      server_name = "mx.fern.garden";
      listeners = [
        {
          bind_addresses = [ "0.0.0.0" ];
          port = 8008;
          x_forwarded = true;
          type = "http";
          tls = false;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = false;
            }
          ];
        }
      ];
      report_stats = false;
      trusted_key_servers = [
        {
          server_name = "matrix.org";
        }
      ];
    };
  };

  services.caddy.virtualHosts."mx.fern.garden, mx.fern.garden:8448" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
            route { crowdsec }
      	    redir / https://fern.garden
      	    reverse_proxy /_matrix/* 127.0.0.1:8008
      	    reverse_proxy /_synapse/client/* 127.0.0.1:8008
      	  '';
  };
}
