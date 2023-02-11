{ rustPlatform, fetchFromGitHub, lib, ... }:
rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.2.7";

  src = fetchFromGitHub {
    repo = pname;
    owner = "nyxkrage";
    rev = "e660a79bcf2aba361e002cdf8845ca1444bb6ad5";
    sha256 = "sha256-LGLkGJGKDcda71TWjzn9Q8kLqTyxGvPaPBJtirV+xDc=";
  };

  cargoSha256 = "sha256-Psc9qErqi3aangNowXxhkEXphFCR7pp+DKTKtk6tMo0=";

  meta = with lib; {
    description = "boxxy puts bad Linux applications in a box with only their files.";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = [ maintainers.nyxkrage ];
  };
}
