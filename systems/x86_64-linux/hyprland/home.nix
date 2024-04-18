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
    inputs.self.homeManagerModules.general
    inputs.self.homeManagerModules.templates
  ];

  home.file = builtins.listToAttrs dotfiles;

  home.packages = with pkgs; [
    clipman
    grim
    mako
    slurp
    tofi
    wayvnc
    wev
    glib
    wf-recorder
    wl-clipboard
    wlr-randr
    waybar
    wtype
    swaylock-effects
    swayidle
  ] ++ [
    pamixer
    pavucontrol
    pulsemixer
    easyeffects
    playerctl
    lame
  ] ++ [
    imagemagick
  ] ++ [
    udiskie
    alacritty
    foot
    tk
    meld
    imv
    gparted
    zathura
  ];

  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
  };
}
