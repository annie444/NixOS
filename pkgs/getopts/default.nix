{
  lib,
  pkgs,
  fetchFromGitHub,
}:
pkgs.fishPlugins.buildFishPlugin rec {
  pname = "getopts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "getopts.fish";
    rev = "1.0.0";
    hash = "sha256-U115FNlQwWMvsmYRsfyb9FqqzVciC+EQMPYWTbRCuUA=";
  };

  meta = with lib; {
    description = "Parse CLI options in Fish.";
    homepage = "https://github.com/jorgebucaran/getopts.fish";
    license = licenses.mit;
    maintainers = [ {
      email = "annie.ehler.4@gmail.com";
      name = "Annie Ehler";
      github = "annie444";
      githubId = 6550634;
    } ];
  };
}
