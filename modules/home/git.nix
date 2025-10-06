{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    userName = "nomnivore";
    userEmail = "6979410+nomnivore@users.noreply.github.com";

    aliases = {
      co = "checkout";
      cm = "commit";
      st = "status";
      br = "branch";
      df = "diff";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      undo = "reset --soft HEAD^";
    };

    extraConfig = {
      url = {
        "https://github.com/" = {
          insteadOf = "gh:";
        };

        "https://gitlab.com/" = {
          insteadOf = "gl:";
        };

        "https://bitbucket.org/" = {
          insteadOf = "bb:";
        };
      };
      push = {
        default = "current";
        autoSetupRemote = "true";
      };
    };
  };

  programs.gh = {
    enable = true;
    package = pkgs.unstable.gh;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
    extensions = with pkgs.unstable; [
      gh-copilot # Copilot AI in the command line
      gh-s # GitHub Search
      gh-poi # Delete merged local branches
    ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My PRs";
          filters = "is:open author:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
        {
          title = "\/nixcfg";
          filters = "is:open repo:nomnivore/nixcfg";
        }
      ];
    };
  };
}
