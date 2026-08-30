{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    claude-code
    gemini-cli
  ];

  modules.extRepos.agents = {
    repo = "nomnivore/agents";
    links = {
      # TODO: generalize (sub)agents and AGENTS.md
      ".agents/skills" = "skills";

      ".claude/CLAUDE.md" = "CLAUDE.md";
      ".claude/skills" = "skills";
      ".claude/agents" = "agents";
    };
  };
}
