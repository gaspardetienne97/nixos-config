# VSCodium Configuration Module
# Sets up VSCodium (open source build of VS Code) with:
# - Essential extensions for development
# - Custom keybindings and settings
# - Theme and appearance configurations
# - Language-specific formatters and tools
{ config, lib, pkgs, ... }:

{
  options.modules.vscodium = {
    enable = lib.mkEnableOption "VSCodium configuration";
  };

  config = lib.mkIf config.modules.vscodium.enable {
    home.packages = [ pkgs.vscodium ];
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        serayuzgur.crates
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        tamasfe.even-better-toml
        bbenoist.nix
        jock.svg
        editorconfig.editorconfig
        esbenp.prettier-vscode
        davidanson.vscode-markdownlint
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        kahole.magit
        bodil.file-browser
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
       
        {
          engineVersion="^1.79.0";lastUpdated="2024-10-24T12:30:06.868479Z";missingTimes=6;name="cody-ai";platform="universal";publisher="sourcegraph";sha256="b/XQkiasAAUg9OxhYEddxdH3SF/K9LOPTHGVmIoD3MA=";version="1.39.1729772971";
          }
      ];
      keybindings = [ ];
      userSettings = {
        "files.autoSave" = "onFocusChange";
        "update.mode" = "none"; # updates are done by nix
        "explorer.confirmDelete" = false;
        "editor.tabSize" = 2;
        "editor.fontSize" = 20;
        "editor.lineNumbers" = "interval";
        "editor.cursorBlinking" = "solid";
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;
        "editor.fontWeight" = "400";
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "breadcrumbs.enabled" = true;
        # git
        "git.confirmSync" = false;
        "git.autofetch" = false;
        "magit.code-path" = "codium";
        # prettier
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "typescript.updateImportsOnFileMove.enabled" = "always";
        # svelte
        "[svelte]" = {
          "editor.defaultFormatter" = "svelte.svelte-vscode";
        };
        # icons
        "workbench.iconTheme" = "catppuccin-vsc-icons";

        # theme

        "workbench.colorTheme" = "Catppuccin Mocha";
        # Sapphire as the accent color
        "catppuccin.accentColor" = "sapphire";

        # we try to make semantic highlighting look good
        "editor.semanticHighlighting.enabled" = true;
        # prevent VSCode from modifying the terminal colors
        "terminal.integrated.minimumContrastRatio" = 1;
        # make the window's titlebar use the workbench colors
        "window.titleBarStyle" = "custom";

      };
    };
  };
}
