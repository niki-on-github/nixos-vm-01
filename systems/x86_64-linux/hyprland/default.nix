{ config, lib, pkgs, inputs, nixpkgs-unstable, nur, hyprland, ... }:
let
  user = "nix";
in
{
  imports = [
    inputs.self.nixosRoles.desktop
    inputs.home-manager.nixosModules.home-manager
  ];
  templates = {
    system = {
      setup = {
        enable = true;
        encrypt = false;
        disk = "/dev/vda";
      };
      desktop = {
        portals = [];
      };
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  
    # pci device: -device vfio-pci,host=<bus>:<slot>.<func>,multifunction=on
    virtualisation.qemu.options = [
      "-vga none"
      "-device virtio-vga-gl,xres=1664,yres=936"
      "-display sdl,gl=on"
      "-audio pa,model=hda"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit nixpkgs-unstable;
      inherit nur;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      ${user} = import ./home.nix;
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
          "input"
          "kvm"
          "video"
          "wheel"
        ];
      };
    };
  };

  programs.hyprland = {
    enable = true;
  };

  services.getty.autologinUser = "${user}";
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  
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
  };}
