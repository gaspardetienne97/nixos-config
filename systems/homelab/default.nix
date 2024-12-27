{
  config,
  ...
}:

{
  imports = [
    ../base.nix
  ];
  modules = {
    caddy.enable = true;
    cloudflared.enable = true;
    direnv.enable = true;
    fail2ban.enable = true;
    firefly.enable = true;
    jellyfin.enable = true;
    nextcloud.enable = true;
    # ollama.enable = true;
    # qbittorrent.enable = true;



}
}