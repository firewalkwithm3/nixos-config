{ config, lib, ... }:
{
  age.secrets.pixelfed = {
    rekeyFile = ../../../secrets/services/pixelfed.age;
    owner = "972";
    group = "971";
  };

  containers.pixelfed = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.20";
    localAddress = "192.168.100.23";
    bindMounts = {
      "${config.age.secrets.pixelfed.path}".isReadOnly = true;
    };

    config =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        pf-localfs-patch = pkgs.writeText "01-local-filesystem.patch" ''
          				diff --git a/config/filesystems.php b/config/filesystems.php
          				index 00254e93..fc1a58f3 100644
          				--- a/config/filesystems.php
          				+++ b/config/filesystems.php
          				@@ -49,11 +49,11 @@ return [
          				             'permissions' => [
          				                 'file' => [
          				                     'public' => 0644,
          				-                    'private' => 0600,
          				+                    'private' => 0640,
          				                 ],
          				                 'dir' => [
          				                     'public' => 0755,
          				-                    'private' => 0700,
          				+                    'private' => 0750,
          				                 ],
          				             ],
          				         ],
        '';
      in
      {
        services.pixelfed = {
          enable = true;
          package = pkgs.pixelfed.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ "${pf-localfs-patch}" ];
          });
          domain = "pixelfed.fern.garden";
          maxUploadSize = "20M";
          secretFile = "/run/agenix/pixelfed";
          nginx = { };
          settings = {
            APP_URL = "https://pixelfed.fern.garden";
            OAUTH_ENABLE = true;
            STORIES_ENABLED = true;
            INSTANCE_PROFILE_EMBEDS = false;
            INSTANCE_POST_EMBEDS = false;
            INSTANCE_LANDING_SHOW_DIRECTORY = false;
            INSTANCE_LANDING_SHOW_EXPLORE = false;
            OPEN_REGISTRATION = false;
            MAX_BIO_LENGTH = 500;
          };
        };
        system.stateVersion = "23.11";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
      };
  };

  services.caddy.virtualHosts."pixelfed.fern.garden" = {
    logFormat = lib.mkForce ''
      output file ${config.services.caddy.logDir}/fern_garden.log { mode 0644 }
    '';
    extraConfig = ''
            route { crowdsec }
      	    reverse_proxy 192.168.100.23:80
      	  '';
  };
}
