{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.nur.hmModules.nur
    inputs.self.homeManagerModules.general
    inputs.self.homeManagerModules.templates
  ];


}
