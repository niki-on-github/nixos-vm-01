{ config, lib, pkgs, inputs, nixpkgs-unstable, nur, hyprland, ... }:
let
  user = "nix";
  cpu = "amd";
in
{
  imports = [
    inputs.self.nixosRoles.desktop
    inputs.home-manager.nixosModules.home-manager
  ];
  templates = {
    system = {
      bootEncrypted = {
        enable = true;
        disk = "/dev/sda";
      };
    };
    services = {
      podman = {
        enable = true;
        user = "${user}";
      };
    };
  };

  users = {
    users = {
      ${user} = {
        isNormalUser = true;
        description = "nix user";
        createHome = true;
        shell = pkgs.zsh;
        password = "asdf";
        home = "/home/${user}";
        extraGroups = [
          "audio"
          "audit"
          "dialout"
          "disk"
          "input"
          "kvm"
          "log"
          "scanner"
          "sshusers"
          "storage"
          "uucp"
          "video"
          "wheel"
        ];
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit nixpkgs-unstable;
      inherit nur;
      inherit hyprland;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      ${user} = import ./home.nix;
    };
  };

  # required for deploy-rs
  nix.settings.trusted-users = [ "root" "${user}" ];

  environment = {
    sessionVariables = {
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  
    loginShellInit = ''
      if [ -f $HOME/.profile ]; then
        source $HOME/.profile
      fi
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
    variables = {
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
    };
  };

  hardware.cpu."${cpu}".updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
