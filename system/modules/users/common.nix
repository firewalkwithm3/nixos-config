{
  # Immutable users
  users.mutableUsers = false;

  # Single user system
  users.users.fern = {
    isNormalUser = true;
    description = "Fern Garden";
    createHome = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
  };
}
