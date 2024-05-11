{ config, lib, pkgs, inputs, nixpkgs-unstable, nur, hyprland, ... }:
let
  user = "nix";
in
{
  imports = [
    inputs.personalModules.nixosModules.general
    inputs.personalModules.nixosModules.templates
    inputs.home-manager.nixosModules.home-manager
  ];
  templates = {
    system = {
      setup = {
        enable = true;
        encrypt = false;
        disk = "/dev/vda";
      };
    };
    hardware = {
        nvidia = {
            enable = true;
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
      "-nographic"
      "-machine pc-q35-8.0"
      "-device pcie-root-port,id=pcie.1,bus=pcie.0,addr=1c.0,slot=1,chassis=1,multifunction=on"
      "-device vfio-pci,host=0e:00.0,bus=pcie.1,addr=00.0,x-vga=on,multifunction=on"
      "-device vfio-pci,host=0e:00.1,bus=pcie.1,addr=00.1"
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
   
  environment = {
    systemPackages = with pkgs; [
      nvtopPackages.full
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
