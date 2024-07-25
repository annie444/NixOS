{
  lib,
  pkgs,
  fetchFromGitHub,
}:
pkgs.fishPlugins.buildFishPlugin rec {
  pname = "dracula";
  version = "06-23-2023";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "fish";
    rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
    hash = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
  };

  meta = with lib; {
    description = "A dark theme for friendly interactive shell (fish)";
    homepage = "https://github.com/dracula/fish";
    license = licenses.mit;
    maintainers = [ {
      email = "annie.ehler.4@gmail.com";
      name = "Annie Ehler";
      github = "annie444";
      githubId = 6550634;
    } ];
  };
}
