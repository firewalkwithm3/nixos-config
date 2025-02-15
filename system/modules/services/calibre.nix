{ pkgs, lib, config, ... }:
{
  services.calibre-web = {
    enable = true;
    package = pkgs.calibre-web.overrideAttrs ({ propagatedBuildInputs ? [ ], ... }: {
      propagatedBuildInputs = propagatedBuildInputs ++ [
        pkgs.python312Packages.python-ldap
        pkgs.python312Packages.flask-simpleldap
      ];
    });
    group = "media";
    listen.ip = "0.0.0.0";
    listen.port = 8090;
    options.calibreLibrary = "/mnt/volume2/media/calibre/library";
  };

	services.calibre-server = {
	  enable = true;
	  host = "0.0.0.0";
	  port = 8089;
	  group = "media";
	  auth = {
	    enable = true;
	    mode = "auto";
	    userDb = "/var/lib/calibre-server/users.sqlite";
	  };
	  libraries = [ "/mnt/volume2/media/calibre/library" ];
	};

  services.caddy.virtualHosts."books.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
	  extraConfig = ''
      route { crowdsec }
	    reverse_proxy 127.0.0.1:8090
	  '';
  };
}
