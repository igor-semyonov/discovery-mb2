{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    fenixPkgs = fenix.packages.${system};
    rustToolchain = with fenixPkgs;
      combine [
        stable.rustc
        stable.cargo
        stable.llvm-tools
        targets.thumbv7em-none-eabihf.stable.rust-std
        stable.clippy
        stable.rust-analyzer
      ];
    # fenixLib = fenix.packages.${system};
    # rustToolchain = fenixLib.complete.toolchain;
  in {
    inherit fenixPkgs;
    devShells.${system}.default = pkgs.mkShell rec {
      nativeBuildInputs = with pkgs; [
        gdb
        gdb-dashboard
        probe-rs-tools
        minicom
        cargo-binutils
      ];
      buildInputs = with pkgs; [
        rustToolchain
        llvmPackages.libunwind
      ];
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    };
  };
}
