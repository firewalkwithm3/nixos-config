{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # clipboard
    wl-clipboard
    wtype
  ];
}
