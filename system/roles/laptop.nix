{
  imports = [
    ./common.nix

    # system config
    ../modules/networking/laptop.nix
    ../modules/users/laptop.nix
    ../modules/audio.nix
    ../modules/desktop-environment.nix
    ../modules/nintendo-switch.nix
    ../modules/impermanence.nix
    ../modules/disko.nix
    ../modules/plymouth.nix
    ../modules/power-management.nix
    ../modules/printing-scanning.nix
    ../modules/yubikey.nix
  ];

  # Permit insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    # fluffychat
    "fluffychat-linux-1.22.1"
    "olm-3.2.16"
  ];
}
