{ pkgs, config, ... }:

{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
    #ollama
    bottom
    ipmicfg
    alacritty
    git
    vscodium
    code-cursor
    eza
    deadnix
    zellij
    #    nh
    #statixs
    sops
    freecad
    age
    nixd
    nil
    nixpkgs-fmt
    caddy
    nixfmt-rfc-style
    vscode-langservers-extracted
    tailwindcss-language-server
    typescript-language-server
    svelte-language-server
    nodePackages_latest.prettier
    starship
    gimp
    lmms
    onlyoffice-desktopeditors
    ardour
    cloudflared
    musescore
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # basic configuration of git
  programs.git = {
    enable = true;
    userName = config.personalConfig.fullName;
    userEmail = config.personalConfig.email;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    #blesh.enable = true;
    enableCompletion = true;

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      nhs = "nh os switch ${config.personalConfig.homeDirectory}/nixos-config";
      nhb = "nh os switch ${config.personalConfig.homeDirectory}/nixos-config --dry --verbose";
      clean = "nh clean all";
      uall = "sudo nixos-rebuild switch --upgrade-all";
      h = "hx .";
    };
  };
  # basic configuration of git, please change to your own
  programs.eza = {
    enable = true;
    git = true;
    icons = true;
  };

}
