{ pkgs, ... }:
let
  nodeNix = (import ./node.nix { inherit pkgs; });
  nodeEnv = (pkgs.callPackage (nodeNix + "/default.nix") { });
in
pkgs.buildGoModule  rec {
  pname = "gitea-build";
  version = "1.19.3-nyx";
  vendorHash = "sha256-gfHyssQrY5r3rQAzonM3Rv/BDIYGEY/PiOZEyoGGeiw=";

  src = pkgs.fetchgit  {
     url = "https://github.com/nyxkrage/gitea";
     rev = "1.19.3";
     hash = "sha256-KQEBq1BFQRLJW9fJq4W1sOsAqOCfNHKY/+cT8rkXxv4=";
  };

  nativeBuildInputs = [
    pkgs.gnumake
    pkgs.go
    pkgs.nodejs
    pkgs.nodePackages.npm
    pkgs.git

  ];

  buildPhase = ''
    ln -s ${nodeEnv.nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeEnv.nodeDependencies}/bin:$PATH"
    TAGS="bindata" VERSION="${version}" make frontend vendor generate release-sources 
  '';

  installPhase = ''
    mkdir -p $out
    cp dist/release/gitea-src-${version}.tar.gz $out
  '';

  outputs = [ "out" ];

  enableParallelBuilding = false;

  meta = with pkgs.lib; {
    description = "Build helper for Gitea";
    homepage = "https://gitea.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nyxkrage ];
    platforms = platforms.all;
  };
}