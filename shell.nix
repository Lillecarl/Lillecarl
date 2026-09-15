let
  flake = import ./default.nix {};
  pkgs = import flake.inputs.nixpkgs {};
in
pkgs.mkShell {
  packages = [
    pkgs.hugo
    pkgs.typos
  ];
}
