{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    claude-code
    gemini-cli
  ];

  modules.extRepos.agents = {
    repo = "nomnivore/agents";
    links = {
      ".claude/CLAUDE.md" = "CLAUDE.md";
      ".claude/skills" = "skills";
      ".claude/agents" = "agents";
    };
  };
}
