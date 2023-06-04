{
  pkgs,
  lib,
  fetchFromGitHub,
  craneLib,
}:
craneLib.buildPackage rec {
  pname = "moonrepo";
  version = "v1.7.1";

  nativeBuildInputs = [
    pkgs.openssl
    pkgs.pkg-config
    pkgs.perl
  ];

  doCheck = false;

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = "moon";
    rev = version;
    sha256 = "sha256-eSW5QOcVuEe1OyY3SQygdtHQSmBuTwYwObLYQ2llXEA=";
  };

  cargoSha256 = "sha256-ct3i5t/+jtoxO4MQPQxLkm5bBgFCj5br+L+1T+7Y4cM=";

  meta = with lib; {
    description = "A task runner and repo management tool for the web ecosystem, written in Rust.";
    homepage = "https://moonrepo.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [nyx];
  };
}
