{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
  };
}
