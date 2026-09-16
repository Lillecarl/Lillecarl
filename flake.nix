{
  inputs = {
    flake-compatish = {
      url = "github:lillecarl/flake-compatish";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The spell check's nixpkgs. default.nix never overrides it, so
    # every machine runs the same typos and the same dictionary; the
    # site build above uses the fleet pin.
    nixpkgs-check.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-check, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # ./., not self: flake evaluation and flake-compatish (self
      # overridden to the raw working copy) both see the repo root here.
      # The filter drops build output and tool state, so a local build
      # and a CI build read one source.
      src = nixpkgs.lib.cleanSourceWith {
        src = ./.;
        filter = path: type:
          !builtins.elem (baseNameOf path) [ ".direnv" ".jj" "public" ]
          && nixpkgs.lib.cleanSourceFilter path type;
      };
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          # The site as CI deploys it.
          site = pkgs.stdenv.mkDerivation {
            name = "lillecarl.com";
            inherit src;
            nativeBuildInputs = [ pkgs.hugo ];
            buildPhase = ''
              export HUGO_CACHEDIR=$TMPDIR/hugo
              hugo --gc --minify
            '';
            installPhase = "mv public $out";
          };

          default = site;
        });

      checks = forAllSystems (system:
        {
          # crate-ci/typos. _typos.toml carries the words the site
          # means to spell its own way.
          typos = (nixpkgs-check.legacyPackages.${system}).stdenv.mkDerivation {
            name = "typos-check";
            inherit src;
            nativeBuildInputs = [ nixpkgs-check.legacyPackages.${system}.typos ];
            buildPhase = "typos .";
            installPhase = "touch $out";
          };
        });
    };
}
