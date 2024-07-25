{
  lib,
  pkgs,
  fetchFromGitHub,
}:
pkgs.fishPlugins.buildFishPlugin rec {
  pname = "gitnow";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "joseluisq";
    repo = "gitnow";
    rev = "2.12.0";
    hash = "sha256-PuorwmaZAeG6aNWX4sUTBIE+NMdn1iWeea3rJ2RhqRQ=";
  };

  meta = with lib; {
    description = "Speed up your Git workflow. 🐠";
    homepage = "https://github.com/joseluisq/gitnow";
    license = licenses.mit;
    maintainers = [ {
      email = "annie.ehler.4@gmail.com";
      name = "Annie Ehler";
      github = "annie444";
      githubId = 6550634;
    } ];
  };
}
