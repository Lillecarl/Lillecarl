let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  flake-compatish = import (builtins.fetchTree lock.nodes.flake-compatish.locked);
  flake = flake-compatish {
    source = ./.;
    overrides = {
      self = ./.;
      # Machines of this fleet build from the pinned checkout; a
      # fresh runner has no /etc/nixpkgs and falls back to what the
      # lockfile says.
      nixpkgs =
        if builtins.pathExists /etc/nixpkgs
        then /etc/nixpkgs
        else builtins.fetchTree {
          inherit (lock.nodes.nixpkgs.locked) type owner repo rev;
        };
    };
  };
in
flake.outputs // {
  # Current-system shortcuts for the command line: `nix build --file . site`
  # and `nix build --file . checks`.
  site = flake.impure.packages.site;
  checks = flake.impure.checks;
}
