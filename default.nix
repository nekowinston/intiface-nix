{pkgs ? import <nixpkgs> {}}: {
  lib = import ./lib {inherit pkgs;};
  modules = import ./modules;
  overlays = import ./overlays;

  intiface-central = pkgs.callPackage ./pkgs/intiface-central {};
  intiface-engine = pkgs.callPackage ./pkgs/intiface-engine {};

  docs = pkgs.callPackage ./docs {};
}
