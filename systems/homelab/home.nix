{ pkgs, config, ... }:

{
 imports = [
  ../base/home.nix 
 ];
   
home.packages = with pkgs; [
    code-cursor
    freecad
    ipmicfg
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
  ];

}
