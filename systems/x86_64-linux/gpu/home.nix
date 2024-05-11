{ pkgs, inputs, lib, config, ... }: 
{
  imports = [
    inputs.nur.hmModules.nur
    inputs.self.homeManagerModules.general
    inputs.self.homeManagerModules.templates
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      la = "ls -la";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
}
