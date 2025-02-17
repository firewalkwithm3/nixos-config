{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # Login manager
  services.xserver.displayManager.gdm.enable = true;

  # Window manager
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  systemd.user.services.niri-flake-polkit = {
    wants = lib.mkForce [ ];
    requisite = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Brightness control
  hardware.brillo.enable = true;
}
