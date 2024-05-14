{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    gomod2nix.url = "github:niklashhh/gomod2nix/fix-recursive-symlinker";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      mkConfig = builder: (inputs.flake-utils.lib.eachSystem [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
        (system: builder system (import inputs.nixpkgs {
          inherit system;
        })));
    in
    mkConfig (system: pkgs:
      let
        app_server_image = pkgs.callPackage ./default.nix { };
      in
      {
        packages.app_server_image = app_server_image;
        packages.default = app_server_image;
      });
}
