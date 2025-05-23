# VSCodium Configuration Module
# Sets up VSCodium (open source build of VS Code) with:
# - Essential extensions for development
# - Custom keybindings and settings
# - Theme and appearance configurations
# - Language-specific formatters and tools
{ config
, lib
, pkgs
, ...
}:

{
  options.modules.vscodium = {
    enable = lib.mkEnableOption "VSCodium configuration";
  };

  config = lib.mkIf config.modules.vscodium.enable {
    home.packages = [ pkgs.vscodium ];
    programs.vscode = {
      enable = true;

      package = pkgs.vscodium;
      profiles = {
        default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions = with pkgs.vscode-marketplace; [
            serayuzgur.crates
            # Interface Improvements
            eamodio.gitlens
            usernamehw.errorlens
            pflannery.vscode-versionlens
            yoavbls.pretty-ts-errors
            wix.vscode-import-cost
            gruntfuggly.todo-tree
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            # Web Dev
            # dbaeumer.vscode-eslint
            esbenp.prettier-vscode
            csstools.postcss
            stylelint.vscode-stylelint
            bradlc.vscode-tailwindcss
            davidanson.vscode-markdownlint
            unifiedjs.vscode-mdx
            tamasfe.even-better-toml
            jock.svg
            editorconfig.editorconfig
            esbenp.prettier-vscode
            davidanson.vscode-markdownlint
            svelte.svelte-vscode
            bradlc.vscode-tailwindcss
            bodil.file-browser
            sleistner.vscode-fileutils
            # Git
            github.vscode-pull-request-github
            mhutchie.git-graph
            # Nix
            bbenoist.nix
            jnoortheen.nix-ide
            jetpack-io.devbox
            arrterian.nix-env-selector
            # GraphQL
            graphql.vscode-graphql-syntax
            graphql.vscode-graphql
            # AI
            sourcegraph.cody-ai
            github.copilot-chat
            github.copilot
          ];
          keybindings = [ ];
          userSettings = {
            "files.autoSave" = "onFocusChange";
            "update.mode" = "none"; # updates are done by nix
            "explorer.confirmDelete" = false;
            "editor.tabSize" = 4;
            "editor.fontSize" = 20;
            "editor.lineNumbers" = "interval";
            "editor.cursorBlinking" = "solid";
            "editor.fontFamily" = "Fira Code";
            "editor.fontLigatures" = true;
            "editor.fontWeight" = "400";
            "editor.formatOnSave" = true;
            "editor.formatOnPaste" = true;
            "breadcrumbs.enabled" = true;
            "workbench.sideBar.location" = "right";

            # Whitespace
            "files.trimTrailingWhitespace" = true;
            "files.trimFinalNewlines" = true;
            "files.insertFinalNewline" = true;
            "diffEditor.ignoreTrimWhitespace" = false;
            # git
            "git.confirmSync" = false;
            "git.autofetch" = false;
            "git.enableCommitSigning" = true;
            "git-graph.repository.sign.commits" = true;
            "git-graph.repository.sign.tags" = true;
            "git-graph.repository.commits.showSignatureStatus" = true;

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
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };

            /*
            *TODO get nix language server definition from helix config
          "nix.enableLanguageServer" = true;
          "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
          "nix.serverPath" = "${pkgs.nil}/bin/nil";
          "nix.serverSettings"."nil"."formatting"."command" = [ "${pkgs.alejandra}/bin/alejandra" ];
            */

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
    };
  };
}
