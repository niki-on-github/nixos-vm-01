# Terraform

Deploy the NixOS GPU VM. I was not able to get the nixos build in vm function to use with gpu passthrough. The gpu was shown inside the vm but the nvidia driver is not behaving correctly. Workaround for now is to use this terraform manifest.

## Setup

```sh
nix build '.#nixosConfigurations.gpu.config.system.build.qcow2'
terraform init
terraform plan
terraform apply
sudo virsh net-dhcp-leases default
```

## Delete

If `terraform destroy` not works use:

```bash
virsh --connect qemu:///system undefine terraform-gpu
````
