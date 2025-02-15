{ pkgs, ... }:
{
  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  # Scanning
  hardware.sane.enable = true;
}
