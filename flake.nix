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
      in
      {
        packages = {
          uiua = uiua.packages.${system}.default;
        };
        devShell = pkgs.mkShell {
          name = "uiua shell";
          packages = [
            pkgs.nil
            self.packages.${system}.uiua
          ];
        };
      }
    );
}