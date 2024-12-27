# Caddy Server Overlay
# Extends base Caddy with Cloudflare DNS validation support
# Features:
# - Cloudflare DNS plugin integration
# - Custom build configuration
# - Automatic module imports
# - Vendor dependency management

inputs: _final: prev:

let
  # List of additional Caddy plugins to include
  plugins = [ "github.com/caddy-dns/cloudflare" ];
  
  # Helper functions to generate Go imports and dependencies
  goImports = prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "   _ \"${pkg}\"\n");
  goGets = prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "go get ${pkg}\n      ");

  # Main Caddy entry point with Cloudflare plugin
  main = ''
    package main
    import (
    	caddycmd "github.com/caddyserver/caddy/v2/cmd"
    	_ "github.com/caddyserver/caddy/v2/modules/standard"
    ${goImports}
    )
    func main() {
    	caddycmd.Main()
    }
  '';

in {
  # Custom Caddy build with Cloudflare support
  caddycloudflare = prev.buildGo120Module {
    pname = "caddycloudflare";
    version = prev.caddy.version;
    runVend = true;

    subPackages = [ "cmd/caddy" ];

    src = prev.caddy.src;

    vendorSha256 = "sha256:mwIsWJYKuEZpOU38qZOG1LEh4QpK4EO0/8l4UGsroU8=";

    overrideModAttrs = (_: {
      preBuild = ''
        echo '${main}' > cmd/caddy/main.go
        ${goGets}
      '';
      postInstall = "cp go.sum go.mod $out/ && ls $out/";
    });

    postPatch = ''
      echo '${main}' > cmd/caddy/main.go
      cat cmd/caddy/main.go
    '';

    postConfigure = ''
      cp vendor/go.sum ./
      cp vendor/go.mod ./
    '';

    meta = with prev.lib; {
      homepage = "https://caddyserver.com";
      description =
        "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
      license = licenses.asl20;
      maintainers = with maintainers; [ Br1ght0ne techknowlogick ];
    };
  };
}
