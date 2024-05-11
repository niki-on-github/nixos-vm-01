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

/*
    "-machine pc-q35-8.0,usb=off,vmport=off,dump-guest-core=off"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":16,\"chassis\":1,\"id\":\"pci.1\",\"bus\":\"pcie.0\",\"multifunction\":true,\"addr\":\"0xE\"}'"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":17,\"chassis\":2,\"id\":\"pci.2\",\"bus\":\"pcie.0\",\"addr\":\"0xE.0x1\"}'"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":18,\"chassis\":3,\"id\":\"pci.3\",\"bus\":\"pcie.0\",\"addr\":\"0xE.0x2\"}'"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":19,\"chassis\":4,\"id\":\"pci.4\",\"bus\":\"pcie.0\",\"addr\":\"0xE.0x3\"}'"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":20,\"chassis\":5,\"id\":\"pci.5\",\"bus\":\"pcie.0\",\"addr\":\"0xE.0x4\"}'"
      "-device '{\"driver\":\"pcie-root-port\",\"port\":21,\"chassis\":6,\"id\":\"pci.6\",\"bus\":\"pcie.0\",\"addr\":\"0xE.0x5\"}'"
      "-device '{\"driver\":\"vfio-pci\",\"host\":\"0000:0e:00.0\",\"id\":\"hostdev1\",\"bus\":\"pci.3\",\"addr\":\"0x0\"}'"
      "-device '{\"driver\":\"vfio-pci\",\"host\":\"0000:0e:00.1\",\"id\":\"hostdev1\",\"bus\":\"pci.4\",\"addr\":\"0x0\"}'"
      "-device '{\"driver\":\"vfio-pci\",\"host\":\"0000:0e:00.2\",\"id\":\"hostdev1\",\"bus\":\"pci.5\",\"addr\":\"0x0\"}'"
      "-device '{\"driver\":\"vfio-pci\",\"host\":\"0000:0e:00.3\",\"id\":\"hostdev1\",\"bus\":\"pci.6\",\"addr\":\"0x0\"}'"

      */

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
