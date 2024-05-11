# Terraform

Deploy the OPNsense VM.

## Setup

In my repositroy hosted on my personal git server i use a git subvolume of my OPNsense backup config for the path `/terraform/config`. In addition i store the `password` in `secrets.sops.yaml` in this repository.


## Usage

### Cheat-Sheet

```bash
terraform init
terraform plan
terraform apply
sudo virsh net-dhcp-leases default
terraform destroy
```

## Requirements

```bash
sudo mkdir -p /var/lib/libvirt/images
virsh --connect qemu:///system pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>/var/lib/libvirt/images</path>
  </target>
</pool>
EOF
virsh --connect qemu:///system pool-start default
virsh --connect qemu:///system pool-autostart default
```

## Connect

```bash
virt-viewer --connect qemu+ssh://nix@server02.lan:22/system terraform-opnsense
```


## Delete

If `terraform destroy` not works use:


```bash
virsh --connect qemu:///system undefine terraform-opnsense
````
