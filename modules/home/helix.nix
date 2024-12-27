# Helix Editor Configuration Module
# Configures the modern modal text editor with:
# - Language server integrations
# - Formatting tools configuration
# - Custom editor behaviors and appearance
# - Support for multiple programming languages
{ config, lib, pkgs, ... }:

{
  options.modules.helix = {
    enable = lib.mkEnableOption "Helix editor configuration";
  };

  config = lib.mkIf config.modules.helix.enable {
    home.sessionVariables.EDITOR = config.personalConfig.editor;

    programs.helix = {
      enable = true;
      settings = {
        editor = {
          true-color = true;
          line-number = "relative";
          mouse = false;
          cursor-shape.insert = "bar";
          color-modes = true;
          cursorline = true;
          auto-save = true;
          indent-guides.render = true;
          file-picker.hidden = true;
        };
      };

      languages = {
        language-server = {
          tailwindcss-ls = {
            command = "tailwindcss-language-server";
          };
          nixd = {
            command = "nixd";
          };
          nil = {
            command = "nil";
          };
          svelteserver = {
            command = "svelteserver";
          };
          eslint = {
            command = "eslint";
            args = [ "--stdin" ];
          };
          typescript-language-server = {
            command = "typescript-language-server";
            args = [ "--stdio" ];
          };
        };
        language = [
          {
            name = "nix";
            formatter = {
              command = "nixfmt";
            };
            auto-format = true;
            language-servers = [
              "nixd"
              "nil"
            ];
          }
          {
            name = "javascript";
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "typescript"
              ];
            };
            language-servers = [
              "typescript-language-server"
              "eslint"
            ];
            auto-format = true;
          }
          {
            name = "typescript";
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "typescript"
              ];
            };
            language-servers = [
              "typescript-language-server"
              "eslint"
            ];
            auto-format = true;
          }
          {
            name = "svelte";
            formatter = {
              command = "prettier";
              args = [ "--stdin" ];
            };
            auto-format = true;
            language-servers = [
              "tailwindcss-ls"
              "svelteserver"
            ];
          }
        ];
      };
    };
  };
}
