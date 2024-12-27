# Alacritty Terminal Module
# Configures the GPU-accelerated terminal emulator
# Features:
# - FiraCode Nerd Font integration
# - Custom window dimensions and padding
# - Transparency and blur effects
# - Cursor and scrolling customization
# - Color scheme and text rendering options
{ config, lib, pkgs, ... }:

let
  # Common font configuration
  defaultFont = "FiraCode Nerd Font";
in
{
  options.modules.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";
  };

  config = lib.mkIf config.modules.alacritty.enable {
    home.packages = [ pkgs.alacritty ];
    
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          dimensions = {
            columns = 100;
            lines = 25;
          };
          padding = {
            x = 3;
            y = 3;
          };
          dynamic_padding = true;
          blur = true;
          opacity = 0.9;
        };

        env.TERM = "xterm-256color";
        font = {
          normal = {
            family = defaultFont;
            style = "Regular";
          };
          bold = {
            family = defaultFont;
            style = "Bold";
          };
          italic = {
            family = defaultFont;
            style = "Italic";
          };

          size = 12;
        };
        colors = {
          draw_bold_text_with_bright_colors = true;
        };
        cursor = {
          thickness = 5.0e-2;
          style = {
            shape = "Block";
            blinking = "On";
          };
        };
        scrolling.multiplier = 5;

        selection = {
          save_to_clipboard = true;
        };
      };
    };
  };
}
