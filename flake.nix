{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    personalModules = {
      url = "git+https://github.com/niki-on-github/nixos-modules.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    personalHyprland = {
      url = "git+https://github.com/niki-on-github/Hyprland.git";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, deploy-rs, home-manager, sops-nix, agenix, nur, disko, personalModules, personalHyprland, ... } @ inputs:
    let
      inherit (nixpkgs) lib;
      overlays = lib.flatten [
        nur.overlay
        personalModules.overrides
        personalModules.pkgs
      ];
      nixosDeployments = personalModules.utils.deploy.generateNixosDeployments {
        inherit inputs;
        path = ./systems;
        ssh-user = "nix";
        sharedModules = [
          { nixpkgs.overlays = overlays; }
          sops-nix.nixosModules.sops
          agenix.nixosModules.default
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
        ];
      };
    in
    {
      inherit (personalModules) formatter devShells packages nixosModules homeManagerModules nixosRoles homeManagerRoles;
      inherit (nixosDeployments) nixosConfigurations deploy checks;
    };
}
