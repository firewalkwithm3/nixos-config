{ pkgs, ... }:
{
  networking.firewall. allowedTCPPorts = [ 25565 ];

  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.papermc;
    jvmOpts = "-Xms4092M -Xmx4092M";
  };
}
