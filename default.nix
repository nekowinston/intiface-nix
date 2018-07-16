{pkgs ? import <nixpkgs> {}}: {
  lib = import ./lib {inherit pkgs;};
  modules = import ./modules;
  overlays = import ./overlays;

  intiface-engine = pkgs.callPackage ./pkgs/intiface-engine {};
}
