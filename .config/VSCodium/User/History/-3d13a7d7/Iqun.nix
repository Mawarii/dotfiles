{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ansible
    pkgs.python3
    pkgs.python3Packages.python-dateutil
  ];
}
