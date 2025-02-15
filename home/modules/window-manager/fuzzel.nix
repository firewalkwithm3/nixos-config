{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        dpi-aware = "no";
        lines = 12;
        line-height = 12;
        width = 40;
        tabs = 2;
        horizontal-pad = 8;
        vertical-pad = 8;
        inner-pad = 4;
      };
      border = {
        width = 1;
        radius = 0;
      };
    };
  };
}
