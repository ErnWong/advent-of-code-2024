{
  description = "My solutions to advent of code 2024";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    uiua.url = "github:uiua-lang/uiua";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, uiua, flake-utils, self, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        #riscv-pkgs = import nixpkgs {
        #  inherit system;
        #  crossSystem.config = "riscv64";
        #};
      in
      {
        packages = {
          uiua = uiua.packages.${system}.default;
        };
        devShell = pkgs.pkgsCross.riscv64.mkShell {
          name = "uiua shell";
          packages = [
            pkgs.nil
            pkgs.qemu
            self.packages.${system}.uiua
            pkgs.rustc
            pkgs.rustfmt
            pkgs.cargo
            pkgs.swi-prolog
            pkgs.gcc
          ];

          # Needed for rust analyzer
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        };
      }
    );
}