{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../roles/laptop.nix
  ];

  # Hostname
  networking.hostName = "leaf";

  # User password
  age.secrets.user_leaf.rekeyFile = ../../../secrets/users/leaf.age;
  users.users.fern.hashedPasswordFile = config.age.secrets.user_leaf.path;

  # agenix-rekey pubkey
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUqrhHngT/CRIjF6024MqJNy03ed7dSdKpN/7HSpToX";

  # ssh private key
  age.secrets.ssh_leaf.rekeyFile = ../../../secrets/ssh/leaf.age;

  # install drive
  disko.devices.disk.main.device =
    "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_mSATA_250GB_S41MNG0K821487A";

  # luks pass
  age.secrets.luks_leaf.rekeyFile = ../../../secrets/luks/leaf.age;
}
