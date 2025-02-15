{
  imports = [ ./common.nix ];

  # Create media group
  users.groups.media = {
    gid = 1800;
  };

  # Groups
  users.users.fern.extraGroups = [ 
    "media" 
  ];
}
