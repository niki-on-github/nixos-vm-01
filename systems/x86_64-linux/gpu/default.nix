{ config, lib, pkgs, modulesPath, inputs, nixpkgs-unstable, nur, hyprland, ... }:
let
  user = "nix";
in
{
  imports = [
    inputs.personalModules.nixosModules.general
    inputs.personalModules.nixosModules.templates
    inputs.home-manager.nixosModules.home-manager
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];
  templates = {
    hardware = {
        nvidia = {
            enable = true;
        };
    };
    apps = {
        modernUnix.enable = true;
        monitoring.enable = true;
    };
    services = {
        nvidiaDocker.enable = true;
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  };

  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  #NOTE this use https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = 20000;
    format = "qcow2";
    partitionTableType = "hybrid";
  };

  services.xserver = {
    xkb.layout = "de";
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
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
   
  environment = {
    systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };

  programs.zsh.enable = true;

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
          "docker"
          "kvm"
          "video"
          "wheel"
        ];
      };
    };
  };

  services.getty.autologinUser = "${user}";
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  
}
