{
  description = "my blogging setup...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        overlays = [];
      in {
        # I just want to be able to build the files and run hugo serve
        #packages.default = pkgs.stdenv.mkDerivation {
        #  name = "gbrls-blog";
        #  src = ./.;
        #  builder = "${pkgs.hugo}/bin/hugo";
        #  buildInputs = with pkgs; [go];
        #};
        #apps.default = {
        #  type = "app";
        #  program = "${pkgs.hugo}/bin/hugo";
        #};
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            go
          ];
        };
      }
    );
}
