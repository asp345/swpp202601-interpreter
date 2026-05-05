{
  description = "Nix flake for the SWPP 2026 interpreter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
      mkPkgs = system: import nixpkgs { inherit system; };
    in {
      packages = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
          mkRustPackage = rustPlatform:
            { enableLog ? false }:
            rustPlatform.buildRustPackage {
              pname = if enableLog then "swpp-interpreter-log" else "swpp-interpreter";
              version = "0.1.0";
              src = lib.cleanSource ./.;
              cargoLock = {
                lockFile = ./Cargo.lock;
              };
              buildFeatures = lib.optionals enableLog [ "log" ];
              checkFeatures = lib.optionals enableLog [ "log" ];

              meta = with lib; {
                description = "Interpreter for SWPP 2026 assembly programs";
                mainProgram = "main";
                platforms = platforms.linux;
              };
            };
          mkInterpreter =
            mkRustPackage pkgs.rustPlatform;
          mkStaticInterpreter =
            mkRustPackage pkgs.pkgsStatic.rustPlatform;
        in {
          default = mkInterpreter { };
          log = mkInterpreter { enableLog = true; };
          static = mkStaticInterpreter { };
          log-static = mkStaticInterpreter { enableLog = true; };
        }
      );

      apps = forAllSystems (
        system:
        let
          packageSet = self.packages.${system};
        in {
          default = {
            type = "app";
            program = "${packageSet.default}/bin/main";
            meta.description = "Run the SWPP interpreter";
          };
          log = {
            type = "app";
            program = "${packageSet.log}/bin/main";
            meta.description = "Run the SWPP interpreter with the log feature enabled";
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
          packageSet = self.packages.${system};
        in {
          smoke = pkgs.runCommand "swpp-interpreter-smoke" { } ''
            output="$(${packageSet.default}/bin/main ${./testcases/call_basic_return.s} $TMPDIR/call_basic_return.cost)"
            test "$output" = "8"
            test "$(cat "$TMPDIR/call_basic_return.cost")" = "Final Cost : 72"
            touch "$out"
          '';

          log-smoke = pkgs.runCommand "swpp-interpreter-log-smoke" { } ''
            cd "$TMPDIR"
            output="$(${packageSet.log}/bin/main ${./testcases/call_basic_return.s} $TMPDIR/call_basic_return.cost)"
            test "$output" = "8"
            test "$(cat "$TMPDIR/call_basic_return.cost")" = "Final Cost : 72"
            test -f "$TMPDIR/swpp-interpreter-basic.log"
            touch "$out"
          '';
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
              nixfmt
            ];
          };
        }
      );

      formatter = forAllSystems (system: (mkPkgs system).nixfmt);
    };
}
