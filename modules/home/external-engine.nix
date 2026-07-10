{
  config,
  pkgs,
  lib,
  vars,
  ...
}:

let
  externalDir = "${vars.flakePath}/external";
  cfg = config.modules.extRepos;

  generateLinks =
    repoName: repoCfg:
    lib.mapAttrs' (
      homePath: repoPath:
      let
        targetPath =
          if repoPath == "." || repoPath == "" then
            "${externalDir}/${repoName}"
          else
            "${externalDir}/${repoName}/${repoPath}";
      in
      {
        name = homePath;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink targetPath;
        };
      }
    ) repoCfg.links;

  generateSyncScript = repoName: repoCfg: ''
    REPO_PATH="${externalDir}/${repoName}"

    if [ ! -d "$REPO_PATH/.git" ]; then
      echo "External repo '${repoName}' is missing or broken. Cloning..."
      $DRY_RUN_CMD rm -rf "$REPO_PATH"
      $DRY_RUN_CMD mkdir -p "$(dirname "$REPO_PATH")"

      # dynamically construct the url from shorthand
      if $DRY_RUN_CMD ${pkgs.git}/bin/git clone "https://github.com/${repoCfg.repo}.git" "$REPO_PATH"; then
        echo "Successfully cloned ${repoName}"
      else
        echo "ERROR: Failed to clone ${repoName}. Will automatically retry on next rebuild."
        $DRY_RUN_CMD mkdir -p "$REPO_PATH"
      fi
    else
      echo "Syncing upstream changes for '${repoName}'..."
      $DRY_RUN_CMD ${pkgs.git}/bin/git -C "$REPO_PATH" pull --ff-only || {
        echo "WARNING: Git pull failed for ${repoName}. Check for local conflicts."
      }
    fi
  '';
in
{
  options.modules.extRepos = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          repo = lib.mkOption { type = lib.types.str; };
          links = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
          };

        };
      }
    );
    default = { };
  };

  config = lib.mkIf (cfg != { }) {
    home.file = lib.mkMerge (lib.mapAttrsToList generateLinks cfg);

    home.activation.syncExternalRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatStringsSep "\n" (lib.mapAttrsToList generateSyncScript cfg)
    );
  };
}
