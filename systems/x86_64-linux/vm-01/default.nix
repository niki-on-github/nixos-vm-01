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
      setup = {
        enable = false;
        encrypt = false;
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

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;

      #sharedDirectories = {
      #  home = {
      #    source = "$HOME";
      #    target = "/mnt";
      #  };
      #};
    };

    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
      "-audio pa,model=hda"
    ];
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

  virtualisation.vmware.guest.enable = true;

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
        export WLR_RENDERER_ALLOW_SOFTWARE=1
        export WLR_NO_HARDWARE_CURSORS=1
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
