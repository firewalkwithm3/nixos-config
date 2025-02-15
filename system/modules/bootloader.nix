{
  # Enable modifying EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;
}
