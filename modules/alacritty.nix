{ config, pkgs, ... }:
{
  # alacritty - a cross-platform, GPU-accelerated terminal emulator
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
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
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

}
