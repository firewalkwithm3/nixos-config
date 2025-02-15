{ lib, ... }:
{
  systemd.user.services.wlsunset.Unit.After = lib.mkForce [ "graphical-session.target" ];

  services.wlsunset = {
    enable = true;
    systemdTarget = "graphical-session.target";
    latitude = -27.6;
    longitude = 121.6;
  };
}
