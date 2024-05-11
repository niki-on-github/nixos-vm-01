# My NixOS VM 01

## Testing

```bash
nix run '.#nixosConfigurations.vm-01.config.system.build.vm
```

or build vm with:

```sh
nixos-rebuild build-vm --flake '.#gpu'
```

then run vm with

```sh
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_0
virsh --connect qemu:///system nodedev-detach pci_0000_0e_00_1
sudo -E ./result/bin/run-gpu-vm
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_0
virsh --connect qemu:///system nodedev-reattach pci_0000_0e_00_1
```

TODO: the gpu vm is not working. Need future investigation.

Now build with

```sh
nix build '.#nixosConfigurations.gpu.config.system.build.qcow2'
```

But need huge space on `/tmp`.
