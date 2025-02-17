{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  moduleCfg = {
    "tray" = {
      icon-size = 13;
    };
    "idle_inhibitor" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        activated = "󰅶";
        deactivated = "󰒲";
      };
    };
    "niri/workspaces" = {
      format = "{icon}";
      format-icons = {
        browser = "󰈹";
        work = "󰈙";
        games = "󰊗";
        media = "󰝚";
        chat = "󰭹";
        default = "";
      };
    };
    "network#wifi" = {
      interface = "wlp3s0";
      tooltip = true;
      tooltip-format = "{essid}";
      format = "{icon}";
      format-disconnected = "";
      format-icons = [
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];
      on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    };
    "network#eth" = {
      interface = "enp0s31f6";
      tooltip = false;
      format = "󰈀";
      format-disconnected = "";
      on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    };
    "network#wireguard" = {
      interface = "forest";
      tooltip = false;
      format = "󰖂";
      format-disconnected = "";
      on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
    };
    "clock" = {
      tooltip = true;
      tooltip-format = "{:%A %d %B}";
      format = "󰥔  {:%H:%M}";
      timezone = "Australia/Perth";
    };
    "wireplumber" = {
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
      tooltip = false;
      format = "{icon} {volume}%";
      format-muted = "󰝟";
      format-icons = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
    };
    "battery#bat0" = {
      bat = "BAT0";
      tooltip = true;
      tooltip-format = "Internal: {capacity}%";
      states = {
        warning = 30;
        critical = 15;
      };
      format-icons = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
      format = "{icon}";
      format-charging = "󰂄";
    };
    "battery#bat1" = {
      bat = "BAT1";
      tooltip = true;
      tooltip-format = "External: {capacity}%";
      states = {
        warning = 30;
        critical = 15;
      };
      format-icons = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
      format = "{icon}";
      format-charging = "󰂄";
    };
  };
in
{
  systemd.user.services.waybar.Unit.After = lib.mkForce [ "graphical-session.target" ];

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      laptopDisplay = moduleCfg // {
        layer = "top";
        position = "top";
        output =
          if osConfig.networking.hostName == "garden" then
            "eDP-1"
          else if osConfig.networking.hostName == "leaf" then
            "LVDS-1"
          else
            null;
        modules-left = [ "niri/workspaces" ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "network#wireguard"
          "network#eth"
          "network#wifi"
          "battery#bat0"
          "battery#bat1"
          "wireplumber"
          "clock"
        ];
      };
      secondaryDisplay = moduleCfg // {
        layer = "top";
        position = "top";
        output =
          if osConfig.networking.hostName == "garden" then
            "!eDP-1"
          else if osConfig.networking.hostName == "leaf" then
            "!LVDS-1"
          else
            null;
        modules-left = [ "niri/workspaces" ];
      };
    };
  };
}
