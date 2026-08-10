{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };

  environment.localBinInPath = true;
}
