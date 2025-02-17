{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../roles/laptop.nix

    ../../modules/secureboot.nix
    ../../modules/thunderbolt.nix
    ../../modules/virtualisation.nix
  ];

  # Hostname, host id
  networking.hostName = "garden";

  # VPN
  age.secrets.wireguard_garden.rekeyFile = ../../../secrets/networking/wireguard/garden.age;

  networking.wg-quick.interfaces = {
    forest = {
      address = [ "10.1.0.2/24" ];
      dns = [ "10.0.1.1" ];
      mtu = 1380;
      privateKeyFile = config.age.secrets.wireguard_garden.path;
      peers = [
        {
          publicKey = "3838nTriit2ZaqnQZykDcQEKsBBDiXPW+DUKretu9RI=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "103.115.191.242:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Fix throttling issue on T480
  services.throttled.enable = true;

  # User password
  age.secrets.user_garden.rekeyFile = ../../../secrets/users/garden.age;
  users.users.fern.hashedPasswordFile = config.age.secrets.user_garden.path;

  # agenix-rekey
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEp5zVloqXFtLEVCl44MwvdkfzIL4MsLqmENXjgPfnQ";

  # Root drive
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLW256HEHP-000L7_S35ENA1K324390";

  # ssh private key
  age.secrets.ssh_garden.rekeyFile = ../../../secrets/ssh/garden.age;

  # luks pass
  age.secrets.luks_garden.rekeyFile = ../../../secrets/luks/garden.age;
}
