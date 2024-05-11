# My NixOS VM Experiments

## Usage

```bash
nix run '.#nixosConfigurations.${VM_NAME}.config.system.build.vm
```

For the gpu vm i use the manifests from `./terraform/` directory.

### Personal Notes

Not working trials for my gpu passthrou vm:

```sh
nixos-rebuild build-vm --flake '.#gpu'
```

```sh
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_0
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_1
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_2
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_3
sudo -E ./result/bin/run-gpu-vm
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_0
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_1
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_2
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_3
```
