# Homelab

An overview of my homelab.

## NAS 

[Hardware](hardware/nas/README.md)

### Storage

- **NVME** for apps, media and general storage
- **SSD** for internal purposes
- **HDD** for archiving and backups

## NUC

[Hardware](hardware/nuc/README.md)
### Apps

- **Ad Block / DNS** - [PiHole](https://pi-hole.net/) - http://192.168.1.2/admin
- **VPN** - [PiVPN](https://pivpn.io/) ([Wireguard](https://www.wireguard.com/)) - 192.168.1.8
- **Git** - [Gitea](https://about.gitea.com/) - http://192.168.1.211:3000
- **Kubernetes** - [K3s](https://k3s.io/) with [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) - https://argocd.lab.paultibbetts.uk/
- **Databases** - [MySQL](https://www.mysql.com/) and [Postgres](https://www.postgresql.org/)

## Network

### Internet

500 Mbps Fibre

### DNS

[Pi-hole](https://pi-hole.net/) running on an Ubuntu LXC container in Proxmox on the Intel NUC.

It also blocks adverts.

Pi-hole manages the DNS for the homelab with a Dnsmasq entry:

```
# /etc/dnsmasq.d/02-homelab.conf
address=/cloud.paultibbetts.uk/192.168.1.4
```

This needed a restart with `pihole restartdns`.

### LAN

[Ubiquiti Flex 10 GbE](https://techspecs.ui.com/unifi/switching/unifi-flex-xg?s=uk)

[TP-Link Managed Network Switch 8 Port Gigabit](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/)

[D-Link Mesh](https://eu.dlink.com/uk/en/products/m15-eagle-pro-ai-ax1500-mesh-system) setup in bridge mode.

### VPN

[Wireguard](https://www.wireguard.com/) installed on an Ubuntu Server VM in Proxmox on the Intel NUC.
