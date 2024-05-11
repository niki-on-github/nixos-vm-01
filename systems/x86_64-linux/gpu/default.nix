{ config, lib, pkgs, modulesPath, inputs, nixpkgs-unstable, nur, ... }:
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
        nvidia.enable = true;
    };
    apps = {
        modernUnix.enable = true;
        monitoring.enable = true;
    };
    services = {
        nvidiaDocker.enable = true;
        ssh.enable = true;
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 6;
      writableStoreUseTmpfs = false;
    };
  };

  # pci device: -device vfio-pci,host=<bus>:<slot>.<func>,multifunction=on
  /*
  virtualisation.qemu.options = [
    "-vga none"
    "-nographic"
    "-machine pc-q35-8.0"
    "-device pcie-root-port,id=pcie.1,bus=pcie.0,addr=1c.0,slot=1,chassis=1,multifunction=on"
    "-device vfio-pci,host=0e:00.0,bus=pcie.1,addr=00.0,x-vga=on,multifunction=on"
    "-device vfio-pci,host=0e:00.1,bus=pcie.1,addr=00.1"
    "-device vfio-pci,host=0e:00.2,bus=pcie.1,addr=00.2"
    "-device vfio-pci,host=0e:00.3,bus=pcie.1,addr=00.3"
  ];
  */

  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # required to be able to set the final disk size in terraform
  system.activationScripts.autoResizeNixosRoot = {
    text = ''
      ${pkgs.cloud-utils}/bin/growpart /dev/vda 1
      ${pkgs.e2fsprogs}/bin/resize2fs /dev/vda1
    '';
  };

  #NOTE this use https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
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
  services.qemuGuest.enable = true;
  
}
