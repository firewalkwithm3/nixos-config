{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      mode = "no-cursor";
      enableFishIntegration = true;
    };
    settings = {
      window_padding_width = 8;
      allow_remote_control = "yes";
    };
  };
}
