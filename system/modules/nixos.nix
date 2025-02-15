{ config, ... }:
{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Auto-upgrade
  age.secrets.github.rekeyFile = ../../secrets/github.age;

  nix.extraOptions = ''
    !include ${config.age.secrets.github.path}
  '';

  systemd.extraConfig = "DefaultLimitNOFILE=2048";

  system.autoUpgrade = {
    enable = true;
    dates = "3:00";
    flake = "github:firewalkwithm3/nix";
  };

  # Cleanup old generations
  nix.gc = {
    automatic = true;
    dates = "Mon *-*-* 04:00:00";
    options = "--delete-older-than 7d";
  };

  # Optimise store
  nix.optimise = {
    automatic = true;
    dates = [ "Mon *-*-* 05:00:00" ];
  };

  # State version
  system.stateVersion = "24.05";
}
