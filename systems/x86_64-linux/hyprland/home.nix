{ pkgs, inputs, lib, config, ... }: 
let
  generateFiles = files: (map
    (f: {
      name = "${f}";
      value = {
        source = ./dotfiles + "/${f}";
      };
    })
    files
  );

  generateDirectoriesRecursive = directories: (map
    (d: {
      name = "${d}";
      value = {
        source = ./dotfiles + "/${d}";
        recursive = true;
      };
    })
    directories
  );

  filterFileType = type: file:
    (lib.filterAttrs (name: type': type == type') file);

  filterExcludeExtension = extension: file:
    (lib.filterAttrs (name: value: !(lib.hasSuffix extension name)) file);

  filterRegularFiles = filterFileType "regular";

  filterDirectories = filterFileType "directory";

  dotfiles = (generateFiles (lib.attrNames (filterExcludeExtension ".lock" (filterExcludeExtension ".nix" (filterRegularFiles (builtins.readDir ./dotfiles)))))) ++ (generateDirectoriesRecursive(lib.attrNames (filterDirectories (builtins.readDir ./dotfiles))));

in
{
  imports = [
    inputs.nur.hmModules.nur
    inputs.self.homeManagerRoles.desktop
    inputs.self.homeManagerModules.general
    inputs.self.homeManagerModules.templates
  ];


  home.activation = {
    dotfiles-setup = lib.hm.dag.entryAfter [ "installPackages" ] ''
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"      
      [ -d ~/.dotfiles ] || git clone --bare https://github.com/niki-on-github/nixos-dotfiles.git ~/.dotfiles
      [ -f ~/.profiles ] || git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout -f main
      git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no  
    '';
  };

  home.file = {
    "${config.xdg.configHome}/mako/config".enable = lib.mkForce false;
    "${config.xdg.configHome}/hypr/hyprland.conf".enable = lib.mkForce false;
    "${config.programs.zsh.dotDir}/.zshrc".enable = lib.mkForce false;
    "${config.xdg.configHome}/hypr/monitors.conf".text = ''
      monitor=,preferred,auto,auto
     '';
    "${config.xdg.configHome}/hypr/keys.conf".text = ''
      $mainMod = ALT
    '';
    "${config.xdg.configHome}/hypr/devices.conf".text = ''
      # use `hyprctl devices` to identify your devices
    '';
  };

  home.packages = with pkgs; [
    hyprpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
  };
}
