{ pkgs, ... }:
{
  # Bolt
  services.hardware.bolt.enable = true;

  # Rescan PCI devices when TB connected
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="thunderbolt", RUN+="${pkgs.coreutils}/bin/echo 1 > /sys/bus/pci/rescan"
  '';
}
