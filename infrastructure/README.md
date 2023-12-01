# Infrastructure

Managed by [Terraform](https://www.terraform.io/)

## Requirements

- SSH Key
- Terraform
- Proxmox v8
- cloud-init template
- `terraform.tfvars` filled in
- `pass` setup with required passwords

## Usage

```
source secrets.sh
terraform init
terraform apply
```

## Explanations of requirements

### SSH Key

Used for access.

### Terraform

[Install the latest version](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform).

### Proxmox v8

Used for virtualisation.

#### Storage

Datacenter -> hostname -> Directory -> Create: Directory

Choose the M.2 drive, name it `vms` and choose `ext4`.

#### API

Used by Terraform.

##### User

Datacenter -> Permissions -> Users -> Add

Create a user for Terraform.

##### Token

Datacenter -> Permissions -> API Tokens -> Add

Uncheck "Privilege Separation"

##### Role

###### User

Datacenter -> Permissions -> Add

```
Path: /
User: username@pam
Role: PVEVMAdmin
```
###### Storage

Datacenter -> Permissions -> Add

```
Path: /storage/vms
User: username@pam
Role: Administrator
```

### cloud-init template

`cloud-init` is used for early-stage initialization of VMs.

Specifically it is used here to set the IP of the VM and to add my SSH key.

#### On local machine

These steps can be performed on the local machine to make it faster.

##### Download

Download Ubuntu server cloud-init image

```
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

##### Install QEMU guest agent

```
# install required packages
sudo apt update -y && sudo apt install libguestfs-tools -y

# add qemu-guest-agent into the image
sudo virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
```

##### Upload to Proxmox host

```
scp jammy-server-cloudimg-amd64.img root@192.168.1.131:/root/
```

#### On Proxmox host

The following commands will create a VM to use as the template.

##### Prepare the VM

```
qm create 9000 --name "ubuntu-22-04-cloud-init-template" --memory=2048 --cores=2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img vms
# grab the name of the disk to use below
qm set 9000 --scsihw virtio-scsi-pci --scsi0 vms:9000/vm-9000-disk-0.raw
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 vms:cloud-init
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
```

##### Convert VM to a template

```
qm template 9000
```

### `terraform.tfvars`

Fill in the required variables.

### `pass`

Password manager.

#### Installation

`sudo apt-get install pass`

#### Setup

```
gpg --full-generate-key
# create and store the password in 1Password
gpg --list-secret-keys --keyid-format LONG
# sec   rsa4096/7FB534F77F0CC252 2023-07-15 [SC]
#               ^ copy this    ^
pass init 7FB534F77F0CC252
```

#### Add passwords

```
# see secrets.sh for passwords that need adding
pass insert passwordname
```