# Ollama module - Local LLM runner
# Provides configuration for running large language models locally
# Features:
# - CPU/GPU acceleration support
# - Local model management
# - API endpoint for model interaction
{ config, lib, pkgs, ... }:

{
  options.modules.ollama = {
    enable = lib.mkEnableOption "Ollama support";
  };

  config = lib.mkIf config.modules.ollama.enable {
    environment.systemPackages = [ pkgs.ollama ];
    # Enable Ollama support
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}


