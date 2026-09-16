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
          !builtins.elem (baseNameOf path) [ ".direnv" ".jj" "public" "__pycache__" ]
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

          # The site as an agent reads it: for every sitemap page, a
          # screen.png (light, full page), a dark.png (emulated
          # prefers-color-scheme) and a print.pdf (print media -- the
          # CV's print mode included). nix/render.py says why raw CDP.
          views = pkgs.stdenv.mkDerivation {
            name = "lillecarl-views";
            src = site;
            nativeBuildInputs = [
              pkgs.chromium
              pkgs.fontconfig
              pkgs.dejavu_fonts
              (pkgs.python3.withPackages (ps: [ ps.websockets ]))
            ];
            buildPhase = ''
              export HOME=$TMPDIR
              # No /etc/fonts in the sandbox: name the fonts, or text
              # does not draw at all. The include is what maps the
              # generic `monospace` the site asks for to a real face.
              # This lives in buildPhase and not preBuild: a custom
              # buildPhase replaces the default one, and the default
              # is what runs preBuild.
              export FONTCONFIG_FILE=$TMPDIR/fonts.conf
              cat > $FONTCONFIG_FILE <<EOF
              <fontconfig>
                <include>${pkgs.fontconfig.out}/etc/fonts/fonts.conf</include>
                <dir>${pkgs.dejavu_fonts}</dir>
                <dir>${pkgs.noto-fonts}</dir>
                <cachedir>$TMPDIR/fontcache</cachedir>
              </fontconfig>
              EOF
              python ${./nix/render.py} . $out
            '';
            dontInstall = true;
            dontFixup = true;
          };

          default = site;

          # Everything above, rendered for review: PDF and PNG.
          render = pkgs.callPackage ./render.nix { inherit site; };
        });

      checks = forAllSystems (system:
        let pkgs = nixpkgs-check.legacyPackages.${system}; in
        {
          # crate-ci/typos. _typos.toml carries the words the site
          # means to spell its own way.
          typos = pkgs.stdenv.mkDerivation {
            name = "typos-check";
            inherit src;
            nativeBuildInputs = [ pkgs.typos ];
            buildPhase = "typos .";
            installPhase = "touch $out";
          };
        });
    };
}
