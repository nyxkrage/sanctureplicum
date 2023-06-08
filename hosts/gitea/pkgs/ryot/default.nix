{
  pkgs,
  stdenv,
  craneLib,
}: let
  pname = "ryot";
  version = "v1.0.1";
  src = pkgs.fetchFromGitHub {
    owner = "ignisda";
    repo = pname;
    rev = version;
    sha256 = "sha256-rtj6L0oVf+Jxjt5cOHzJSmhbxisiLl2ATIlLy06N/Xs=";
  };
  nodeDependencies = (pkgs.callPackage ./node {}).nodeDependencies;
  cargoDependencies = craneLib.vendorCargoDeps {
    inherit src;
  };
in
  stdenv.mkDerivation rec {
    inherit pname version src;

    nativeBuildInputs = [
      (pkgs.callPackage ../moonrepo {inherit craneLib;})
      pkgs.nodejs
      pkgs.rustc
      pkgs.cargo
    ];

    buildPhase = ''
      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"
      moon run frontend:build
      mkdir -p .cargo
      cp ${cargoDependencies}/config.toml .cargo/config.toml
      cargo build --release --bin ryot
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp target/release/ryot $out/bin/ryot
    '';
  }
