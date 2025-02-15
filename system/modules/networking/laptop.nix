{ config, ... }:
{
  imports = [ ./common.nix ];

  age.secrets.networkmanager.rekeyFile = ../../../secrets/networking/networkmanager.age;

  # wifi
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "forest" ];
    ensureProfiles = {
      environmentFiles = [ config.age.secrets.networkmanager.path ];
      profiles = {
        mycelium = {
          connection = {
            id = "mycelium";
            type = "wifi";
            interface-name = "wlp3s0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "fungi 5GHz";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$MYCELIUM_PSK";
          };
          ipv4.method = "auto";
          ipv6.method = "disabled";
        };
        flowerbed = {
          connection = {
            id = "flowerbed";
            type = "wifi";
            interface-name = "wlp3s0";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "flowerbed";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$FLOWERBED_PSK";
          };
          ipv4.method = "auto";
          ipv6.method = "disabled";
        };
      };
    };
  };
}
