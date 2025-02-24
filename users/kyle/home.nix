# home.nix
{
  # secrets,
  pkgs,
  nix-index-database,
  username,
  config,
  ...
}:
let
  unstable-packages = with pkgs.unstable; [
    # core binaries/programs that will always be bleeding-edge
    # TODO: take programs from the wsl.nix file
    neofetch # hello world :)

    # cli tools
    wget
    vim
    curl
    unzip
    zip
    ripgrep
    fd

    # charm stuff
    gum
    glow
    skate

    # tui apps
    lazygit
    # TODO: pick a file manager
    nnn
    yazi

    # programming languages/toolkits
    # bun is in 'modules'
    nodejs_22
    pnpm
    go
    rustup
    gleam
  ];

  stable-packages = with pkgs; [
    # packages that are less likely to break with updates / version-conflict
    nil # nix language server
    nixfmt-rfc-style # nix formatter

    xdg-utils

    # stuff needed to make neovim config work
    gcc # c compiler
    pyenv
  ];

  # this could be split into seperate files
  # contained in modules, each containing setup related to their module
  bootstrapScript = pkgs.writeShellScriptBin "bootstrap" (builtins.readFile ../../bootstrap);
in
{
  imports = [
    nix-index-database.hmModules.nix-index

    ../../home-modules/default.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.11";

  xdg.enable = true;

  home.packages =
    stable-packages
    ++ unstable-packages
    ++ [
      # other packages that don't fit in the above lists
      # must be explicit (e.g. `pkgs.gh` instead of `gh`)
      bootstrapScript
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    # TODO: setup gpg
    # probably needs secrets management
    # otherwise creating/setting keys will need to be manual
    git = {
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
    gh = {
      enable = true;
      package = pkgs.unstable.gh;
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "https";
      };
      extensions = with pkgs.unstable; [
        gh-copilot # Copilot AI in the command line

        # Managed below
        # gh-dash # GitHub Dashboard

        gh-s # GitHub Search
        gh-poi # Delete merged local branches
      ];
    };

    gh-dash = {
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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
