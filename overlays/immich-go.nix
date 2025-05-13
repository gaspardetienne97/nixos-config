final: prev: {
  immich-go = prev.buildGoModule
    rec {
      pname = "immich-go";


      version = "0.24.2";
      src = prev.fetchFromGitHub {
        owner = "simulot";
        repo = "immich-go";
        rev = "f1b5b47586e042dfd383e40404c9cc27174854c3";
        hash = "sha256-fw7iq3UrpR25s1+0WzKLd/LBxlJ7V/yFWc7n6ja4wfs="; # You need to update this with the actual hash


        # Inspired by: https://github.com/NixOS/nixpkgs/blob/f2d7a289c5a5ece8521dd082b81ac7e4a57c2c5c/pkgs/applications/graphics/pdfcpu/default.nix#L20-L32
        # The intention here is to write the information into files in the `src`'s
        # `$out`, and use them later in other phases (in this case `preBuild`).
        # In order to keep determinism, we also delete the `.git` directory
        # afterwards, imitating the default behavior of `leaveDotGit = false`.
        # More info about git log format can be found at `git-log(1)` manpage.
        leaveDotGit = true;
        postFetch = ''
          cd "$out"
          git log -1 --pretty=%H > "COMMIT"
          git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > "SOURCE_DATE"
          rm -rf ".git"
        '';

      };

      vendorHash = "sha256-mCcp9FMw4NkHJdPEk6cGX/dMGUy79KAulhWb2kiwQnI=";

      # Disable tests
      doCheck = false;


      # options used by upstream:
      # https://github.com/simulot/immich-go/blob/0.13.2/.goreleaser.yaml
      ldflags = [
        "-s"
        "-w"
        "-extldflags=-static"
        "-X main.version=${version}"
        "-X main.commit=${src.rev}"

      ];




    };

}
