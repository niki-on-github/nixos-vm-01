{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.nur.hmModules.nur
    inputs.self.homeManagerRoles.desktop
    inputs.personalHyprland.homeManagerModules.default
  ];

  home.activation = {
    dotfiles-setup = lib.hm.dag.entryAfter ["installPackages"] ''
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"      
      [ -d ~/.dotfiles ] || git clone --bare https://github.com/niki-on-github/nixos-dotfiles.git
      [ -f ~/.profiles ] || git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout -f main
      git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no  
    '';
  };
  
  home.file = {
    "${config.xdg.configHome}/mako/config".enable = lib.mkForce false;
    "${config.xdg.configHome}/hypr/hyprland.conf".enable = lib.mkForce false;
    "${config.programs.zsh.dotDir}/.zshrc".enable = lib.mkForce false;
  };

  home.packages = with pkgs; [
    hyprpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
  };

  programs.ssh = {
    enable = true;
   };
}
