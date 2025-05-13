final: prev:

{
  immich-go = prev.immich-go.overrideAttrs (old: rec {
    version = "0.24.2";
    src = prev.fetchFromGitHub {
      owner = "simulot";
      repo = "immich-go";
      rev = "v${version}";
      hash = "sha256-JxSiauhuGRYO4mpmWTD1LbTh8y4oT3RJwrpRWY0yftY="; # You need to update this with the actual hash
    };

    vendorHash = "sha256-d0851fb22eab3af978fef8778bca661cfae38490785efd585dad4c624d261c64"; # Update this with the actual vendor hash

    # If there are any other changes required, add them here
  });
}
