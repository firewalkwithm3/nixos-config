{
  programs.aria2 = {
    enable = true;
    settings = {
			max-connection-per-server = 16;
			split = 16;
			max-tries = 0;
			retry-wait = 30;
    };
  };
}
