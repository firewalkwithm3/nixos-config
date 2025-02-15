{
  imports = [ ./common.nix ];

    # Groups
  users.users.fern.extraGroups = [ 
    "video"
    "input"
    "networkmanager"
    "dialout"
    "libvirtd"
    "lp"
    "scanner" 
  ];
}

