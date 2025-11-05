{
  pkgs,
  ...
}:

pkgs.writeShellScriptBin {
  name = "nx-search-pkgs";
  runtimeInputs = with pkgs; [
    fzf
    unstable.nix-search-cli
  ];
  text = ''
    SEARCH_CMD='nix-search --json "$QUERY" -m 40 | jq -s -r "map(select(.type == \"package\") | .package_pname)[]" | uniq'

    RELOAD_CMD="sh -c 'QUERY={q}; [ -z \"\$QUERY\" ] && echo \"\" || $SEARCH_CMD'"

    fzf_args=(
      --multi
      --query ""
      --bind "change:reload:$RELOAD_CMD"
      --phony
      --preview 'nix-search --name {1} -m 1 --details'
      --preview-window 'down:35%:wrap'
      --bind 'alt-p:toggle-preview'
      --color 'preview-fg:-1'
      --preview-label $'Search for Nix packages (Type to search, ENTER to confirm)'
    )

    # 3. Initial command for fzf's startup (pipes an empty line to start with no results).
    pkgs=$(echo "" | fzf "$\{fzf_args[@]}" | xargs)

    exec ns $pkgs
  '';
}
