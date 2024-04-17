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


  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  
  # only gnome work with auto resize for now see https://github.com/NixOS/nixpkgs/issues/239490
  services.xserver = {
    layout = "de";
    enable = true;
    displayManager.sddm.wayland.enable = true;
  };  

  services = {
    desktopManager.plasma6.enable = true;
  };
}
