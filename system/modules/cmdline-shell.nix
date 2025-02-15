{ pkgs, ... }:
{
  # Fish Shell
  programs.fish.enable = true;
  users.users.fern.shell = pkgs.fish;
}
