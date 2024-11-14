{ config, fpm, ... }:
{
  routes = [
    {
      match = [ { host = [ "example.tld" ]; } ];
      handle = [
        {
          "handler" = "subroute";
          "routes" = [
            {
              "handle" = [
                {
                  "handler" = "vars";
                  "root" = "example.tld.root";
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "headers";
                  "response" = {
                    "set" = {
                      "Cache-Control" = [ "max-age=15778463, immutable" ];
                    };
                  };
                }
              ];
              "match" = [
                {
                  "path" = [
                    "*.css"
                    "*.js"
                    "*.mjs"
                    "*.svg"
                    "*.gif"
                    "*.png"
                    "*.jpg"
                    "*.ico"
                    "*.wasm"
                    "*.tflite"
                  ];
                  "query" = {
                    "v" = [ "*" ];
                  };
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "headers";
                  "response" = {
                    "set" = {
                      "Cache-Control" = [ "max-age=15778463" ];
                    };
                  };
                }
              ];
              "match" = [
                {
                  "not" = [
                    {
                      "query" = {
                        "v" = [ "*" ];
                      };
                    }
                  ];
                  "path" = [
                    "*.css"
                    "*.js"
                    "*.mjs"
                    "*.svg"
                    "*.gif"
                    "*.png"
                    "*.jpg"
                    "*.ico"
                    "*.wasm"
                    "*.tflite"
                  ];
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "headers";
                  "response" = {
                    "set" = {
                      "Cache-Control" = [ "max-age=604800" ];
                    };
                  };
                }
              ];
              "match" = [ { "path" = [ "*.woff2" ]; } ];
            }
            {
              "handle" = [
                {
                  "handler" = "headers";
                  "response" = {
                    "deferred" = true;
                    "delete" = [ "X-Powered-By" ];
                    "set" = {
                      "Permissions-Policy" = [ "interest-cohort=()" ];
                      "Referrer-Policy" = [ "no-referrer" ];
                      "Strict-Transport-Security" = [ "max-age=31536000" ];
                      "X-Content-Type-Options" = [ "nosniff" ];
                      "X-Frame-Options" = [ "SAMEORIGIN" ];
                      "X-Permitted-Cross-Domain-Policies" = [ "none" ];
                      "X-Robots-Tag" = [ "noindex; nofollow" ];
                      "X-Xss-Protection" = [ "1; mode=block" ];
                    };
                  };
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "static_response";
                  "headers" = {
                    "Location" = [ "/remote.php/dav" ];
                  };
                  "status_code" = 301;
                }
              ];
              "match" = [ { "path" = [ "/.well-known/carddav" ]; } ];
            }
            {
              "handle" = [
                {
                  "handler" = "static_response";
                  "headers" = {
                    "Location" = [ "/remote.php/dav" ];
                  };
                  "status_code" = 301;
                }
              ];
              "match" = [ { "path" = [ "/.well-known/caldav" ]; } ];
            }
            {
              "handle" = [
                {
                  "handler" = "static_response";
                  "headers" = {
                    "Location" = [ "/index.php{http.request.uri}" ];
                  };
                  "status_code" = 301;
                }
              ];
              "match" = [ { "path" = [ "/.well-known/*" ]; } ];
            }
            {
              "handle" = [
                {
                  "handler" = "static_response";
                  "headers" = {
                    "Location" = [ "/remote.php{http.request.uri}" ];
                  };
                  "status_code" = 301;
                }
              ];
              "match" = [ { "path" = [ "/remote/*" ]; } ];
            }
            {
              "handle" = [
                {
                  "encodings" = {
                    "gzip" = { };
                    "zstd" = { };
                  };
                  "handler" = "encode";
                  "prefer" = [
                    "zstd"
                    "gzip"
                  ];
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "error";
                  "status_code" = 404;
                }
              ];
              "match" = [
                {
                  "not" = [ { "path" = [ "/.well-known/*" ]; } ];
                  "path" = [
                    "/build/*"
                    "/tests/*"
                    "/config/*"
                    "/lib/*"
                    "/3rdparty/*"
                    "/templates/*"
                    "/data/*"
                    "/.*"
                    "/autotest*"
                    "/occ*"
                    "/issue*"
                    "/indie*"
                    "/db_*"
                    "/console*"
                  ];
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "static_response";
                  "headers" = {
                    "Location" = [ "{http.request.orig_uri.path}/" ];
                  };
                  "status_code" = 308;
                }
              ];
              "match" = [
                {
                  "file" = {
                    "try_files" = [ "{http.request.uri.path}/index.php" ];
                  };
                  "not" = [ { "path" = [ "*/" ]; } ];
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "rewrite";
                  "uri" = "{http.matchers.file.relative}";
                }
              ];
              "match" = [
                {
                  "file" = {
                    "split_path" = [ ".php" ];
                    "try_files" = [
                      "{http.request.uri.path}"
                      "{http.request.uri.path}/index.php"
                      "index.php"
                    ];
                  };
                }
              ];
            }
            {
              "handle" = [
                {
                  "handler" = "reverse_proxy";
                  "transport" = {
                    "env" = {
                      "front_controller_active" = "true";
                      "modHeadersAvailable" = "true";
                    };
                    "protocol" = "fastcgi";
                    "root" = "${config.services.nginx.virtualHosts.example.tld.root}";
                    "split_path" = [ ".php" ];
                  };
                  "upstreams" = [ { "dial" = "unix/${fpm.socket}"; } ];
                }
              ];
              "match" = [ { "path" = [ "*.php" ]; } ];
            }
            {
              "handle" = [
                {
                  "handler" = "file_server";
                  "hide" = [ "./Caddyfile" ];
                }
              ];
            }
          ];
        }
      ];
    }
  ];
}
