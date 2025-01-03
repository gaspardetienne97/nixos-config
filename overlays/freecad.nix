{ pkgs, ... }:
final: prev: {
  freecad = prev.freecad.overrideAttrs (oldAttrs: {
    version = "1.0rc1";
    src = pkgs.fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      rev = "1.0rc1";
      hash = "sha256-bhRqWjYtwQ1mzZg03OmTFCt4eVgbc+YZnMNgwvRGvjc=";
    };

    prePatch =
      (oldAttrs.prePatch or "")
      + ''
        ${
          let
            ondselSolver = pkgs.fetchFromGitHub {
              owner = "Ondsel-Development";
              repo = "OndselSolver";
              rev = "6bf651cd31dfdcde8d6842b492b93d284f4579fe";
              hash = "sha256-ONxFATHIHKfzxDeIJlIMl2u/ZMahIk46+T2h4Ac+qrQ=";
            };
            googletest = pkgs.fetchFromGitHub {
              owner = "google";
              repo = "googletest";
              rev = "v1.15.2";
              hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
            };
          in
          ''
            cp -r ${ondselSolver}/* src/3rdParty/OndselSolver
            chmod -R +w src/3rdParty/OndselSolver
            cp -r ${googletest} tests/lib/googletest
            echo "add_subdirectory(googletest)" > tests/lib/CMakeLists.txt
            chmod -R +w tests/lib
          ''
        }
      '';

    patches = (oldAttrs.patches or [ ]) ++ [
      ./NIXOS-don-t-ignore-PYTHONPATH-also-fix-ondsel-pc-paths.patch
    ];

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      pkgs.yaml-cpp
      pkgs.microsoft-gsl
    ];

    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-DINSTALL_TO_SITEPACKAGES:BOOL=OFF"
    ];

    preBuild =
      (oldAttrs.preBuild or "")
      + ''
        export NIX_LDFLAGS="-L${pkgs.yaml-cpp}/lib $NIX_LDFLAGS"
      '';
  });
}
