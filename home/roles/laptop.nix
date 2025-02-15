{
  imports = [
    ./common.nix

    # GUI Programs
    ../modules/programs/firefox.nix
    ../modules/programs/kitty.nix
    ../modules/programs/mpv.nix
    ../modules/programs/nextcloud.nix
    ../modules/programs/misc.nix

    # Window Manager
    ../modules/window-manager/icon-theme.nix
    ../modules/window-manager/default-apps.nix
    ../modules/window-manager/niri.nix
    ../modules/window-manager/wlsunset.nix
    ../modules/window-manager/waybar.nix
    ../modules/window-manager/mako.nix
    ../modules/window-manager/fuzzel.nix
    ../modules/window-manager/swayidle.nix
    ../modules/window-manager/udiskie.nix
    ../modules/window-manager/misc.nix
  ];
}
