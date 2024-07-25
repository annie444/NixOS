{
  lib,
  pkgs,
  fetchFromGitHub,
}:
pkgs.fishPlugins.buildFishPlugin rec {
  pname = "abbreviation-tips";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gazorby";
    repo = "fish-abbreviation-tips";
    rev = "0.7.0";
    hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
  };

  meta = with lib; {
    description = "It helps you remember abbreviations and aliases by displaying tips when you can use them.";
    homepage = "https://github.com/gazorby/fish-abbreviation-tips";
    license = licenses.mit;
    maintainers = [ {
      email = "annie.ehler.4@gmail.com";
      name = "Annie Ehler";
      github = "annie444";
      githubId = 6550634;
    } ];
  };
}
