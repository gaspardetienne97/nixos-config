{
  config,
  ...
}:

{
  imports = [
    ./modules/catppuccin.nix
    ./modules/programs.nix
    ./modules/helix.nix
    ./modules/alacritty.nix
    ./modules/vscodium.nix
    ./personal-config.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.personalConfig.username;
  home.homeDirectory = config.personalConfig.homeDirectory;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
