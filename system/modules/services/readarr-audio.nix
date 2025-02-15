{ lib, ... }:
{
  networking.nat = {
    forwardPorts = [
      { destination = "192.168.100.21:9696"; sourcePort = 9696; }
    ];
  };

  containers.readarr-audio = {
	  autoStart = true;
	  privateNetwork = true;
	  hostAddress = "192.168.100.20";
	  localAddress = "192.168.100.21";
    bindMounts = {
      "volume2" = {
        hostPath = "/mnt/volume2";
        mountPoint = "/mnt/volume2";
        isReadOnly = false;
      };
    };

	  config = { lib, ... }: {
      users.groups.media = {
        gid = 1800;
      };

      services.readarr = {
        enable = true;
        group = "media";
      };

	    system.stateVersion = "23.11";

	    networking = {
	      firewall = {
	        enable = true;
	        allowedTCPPorts = [ 8787 ];
	      };
	      useHostResolvConf = lib.mkForce false;
	    };

	    services.resolved.enable = true;
	  };
  };

  services.caddy.virtualHosts."readarr-audio.ferngarden.net" = {
	  logFormat = lib.mkForce ''
	    output discard
	  '';
	  extraConfig = ''
	    reverse_proxy 127.0.0.1:9000
	  '';
  };
}
