{
  lib,
  pkgs,
  fetchFromGitHub,
}:
pkgs.fishPlugins.buildFishPlugin rec {
  pname = "spark";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "spark.fish";
    rev = "1.2.0";
    hash = "sha256-AIFj7lz+QnqXGMBCfLucVwoBR3dcT0sLNPrQxA5qTuU=";
  };

  meta = with lib; {
    description = "Sparklines for Fish.";
    homepage = "https://github.com/jorgebucaran/spark.fish";
    license = licenses.mit;
    maintainers = [ {
      email = "annie.ehler.4@gmail.com";
      name = "Annie Ehler";
      github = "annie444";
      githubId = 6550634;
    } ];
  };
}
