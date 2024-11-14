{ ... }:
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "sky";
  };
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "sky";
      gnomeShellTheme = true;
      icon.enable = true;
    };
  };
}
