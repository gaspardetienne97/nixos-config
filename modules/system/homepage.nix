{ pkgs
, lib
, config
, ...
}: {

  options.modules.homepage = {
    enable = lib.mkEnableOption "homepage configuration";
  };

  config = lib.mkIf config.modules.homepage.enable
    {
      services.homepage-dashboard = {
        enable = true;
        listenPort = 8082;

        widgets = [{
          resources = {
            label = "System";
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
          {
            resources = {
              label = "Storage";
              disk = "/media";
            };
          }];

        services = [
          {
            "*arr" = [
              {
                "Radarr" = {
                  description = "A movie torrent client";
                  url = "localhost:7878";
                  href = "localhost:7878";
                  type = "radarr";
                  key = "apikeyapikeyapikeyapikeyapikey";
                  enableQueue = true; # optional, defaults to false

                };
              }
              {
                "Sonarr" = {
                  icon = "sonarr.svg";
                  description = "A TV/Anime torrent client";
                  href = "http://localhost:8989";
                  widgets = [{
                    url = "http://localhost:8989";
                    type = "sonarr";
                    key = "apikeyapikeyapikeyapikeyapikey";
                    enableQueue = true; # optional, defaults to false
                  }];

                };
              }
              {
                "Lidarr" = {
                  description = "A music torrent client";
                  url = "localhost:8686";
                  href = "localhost:8686";
                  type = "lidarr";
                  key = "apikeyapikeyapikeyapikeyapikey";
                  enableQueue = true; # optional, defaults to false

                };
              }
              {
                "Readarr" = {
                  description = "A book torrent client";
                  url = "localhost:7878";
                  href = "localhost:7878";
                  type = "readarr";
                  key = "apikeyapikeyapikeyapikeyapikey";
                  enableQueue = true; # optional, defaults to false

                };
              }
              {
                "Prowlar" = {
                  description = "A torrent torrent client";
                  url = "localhost:9696";
                  href = "localhost:9696";
                  type = "prowlar";
                  key = "apikeyapikeyapikeyapikeyapikey";

                };
              }
              {
                "Jellyfin" = {
                  type = "jellyfin";
                  description = "A media server";
                  url = "localhost:8096";
                  href = "localhost:8096";
                  key = "apikeyapikeyapikeyapikeyapikey";
                  enableBlocks = true; # optional, defaults to false
                  enableNowPlaying = true; # optional, defaults to true
                  enableUser = true; # optional, defaults to false
                  showEpisodeNumber = true; # optional, defaults to false
                  expandOneStreamToTwoRows = false; # optional, defaults to true

                };
              }
              {
                "Transmission" = {
                  type = "transmission";
                  description = "A torrent client";
                  url = "http://localhost:9091";
                  href = "http://localhost:9091";
                  username = "username";
                  password = "password"; #TODO get this from sops
                  # rpcUrl: /transmission/ # Optional. Matches the value of "rpc-url" in your Transmission's settings.json file

                };
              }
            ];
          }
          {
            "Misc" = [
              {
                "Firefly-iii" = {
                  description = "A personal finance manager";
                  href = "http://localhost:8080";
                };
              }
              {
                "Immich" = {
                  type = "immich";
                  url = "http://localhost:2283";
                  href = "http://localhost:2283";
                  key = "adminapikeyadminapikeyadminapikey";
                  version = 2;
                };
              }
              {
                "Nextcloud" = {
                  description = "A personal cloud";
                  url = "localhost:8080";
                  href = "localhost:8080";
                  type = "nextcloud";
                  key = "token";

                };
              }
              {
                "Authentik" = {
                  description = "A self-hosted identity provider";
                  href = "localhost:9000";
                };
              }

              {
                "Ollama" = {
                  description = "A local LLM";
                  href = "localhost:11434";
                };
              }
              {
                "SyncYomi" = {
                  description = "A manga synchronizing server";
                  href = "localhost:8282";
                };
              }
            ];
          }
        ];
      };
    };
}
