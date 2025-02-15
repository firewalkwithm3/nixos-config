{
  # udev rule to allow users access to Nintendo Switch
  services.udev.extraRules = ''
    # Nintendo Switch
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", GROUP="users"
  '';
}
