{ pkgs, config, ... }:
let
  basePackages = (import ../base/home.nix { inherit config pkgs; }).home.packages;
in
{
  imports = [
    ../base/home.nix
  ];
  modules = /*  baseModules // */ {
    # alacritty.enable = true;
  };

  home.packages = basePackages ++ (with pkgs; [
    code-cursor
    ipmicfg
    syncyomi
    vscode-langservers-extracted
    tailwindcss-language-server
    typescript-language-server
    svelte-language-server
    nodePackages_latest.prettier
    gimp
    lmms
    onlyoffice-desktopeditors
    ardour
    musescore
    freecad-wayland
    immich-go
  ]);

}
