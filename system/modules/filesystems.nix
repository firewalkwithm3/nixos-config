{ pkgs, config, ... }:
{
  # udisks
  services.udisks2.enable = true;

  # rclone
  environment.systemPackages = [ pkgs.rclone ];
  age.secrets.rclone.rekeyFile = ../../secrets/rclone.age;
  environment.etc."rclone.conf".source = config.age.secrets.rclone.path;

  fileSystems."/mnt/onedrive" = {
    device = "onedrive:/";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/etc/rclone.conf"
    ];
  };
}
