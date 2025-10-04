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
        # Add the stable toolchain components
        stable.rustc
        stable.cargo
        # Add the llvm-tools component, which provides binutils
        stable.llvm-tools
      ];
    # fenixLib = fenix.packages.${system};
    # rustToolchain = fenixLib.complete.toolchain;
  in {
    inherit fenixPkgs;
    devShells.${system}.default = pkgs.mkShell rec {
      nativeBuildInputs = with pkgs; [
        gdb
        probe-rs-tools
        minicom
        cargo-binutils
      ];
      buildInputs = with pkgs; [
        rustToolchain
      ];
      # LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    };
  };
}
