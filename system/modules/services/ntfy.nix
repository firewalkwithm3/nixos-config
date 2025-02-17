{ lib, ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings.base-url = "https://ntfy.ferngarden.net";
    settings.auth-default-access = "deny-all";
  };

  services.caddy.virtualHosts."ntfy.ferngarden.net" = {
    logFormat = lib.mkForce ''
      	    output discard
      	  '';
    extraConfig = ''
      	    reverse_proxy 127.0.0.1:2586
      	  '';
  };
}
