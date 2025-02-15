{ pkgs, config, lib, ... }:
{
  networking.firewall. allowedTCPPorts = [ 8096 ];

  nixpkgs.overlays = with pkgs; [(
    final: prev:
      {
        jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
          installPhase = ''
            runHook preInstall

            # this is the important line
            sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

            mkdir -p $out/share
            cp -a dist $out/share/jellyfin-web

            runHook postInstall
          '';
        });
      }
  )];

  services.jellyfin = {
    enable = true;
    group = "media";
  };

  services.caddy.virtualHosts."jellyfin.fern.garden"= {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
	  extraConfig = ''
      route { crowdsec }
	    reverse_proxy 127.0.0.1:8096
	  '';
  };
}
