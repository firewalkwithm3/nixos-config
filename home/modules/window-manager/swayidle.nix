{ pkgs, lib, ... }:
{
  systemd.user.services.swayidle.Unit.After = lib.mkForce [ "graphical-session.target" ];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.gtklock}/bin/gtklock -d";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.gtklock}/bin/gtklock -d";
      }
    ];
  };
}
