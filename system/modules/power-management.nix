{
  services.thermald.enable = true;
  programs.auto-cpufreq = {
    enable = true;
    settings.battery = {
      enable_thresholds = true;
      start_threshold = 75;
      stop_threshold = 80;
      turbo = "never";
    };
  };
}
