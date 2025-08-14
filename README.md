# Homelab

An overview of my homelab.

## NAS

[Hardware](hardware/nas/README.md)

### Storage

- **NVME** for apps, media and general storage
- **SSD** for internal purposes
- **HDD** for archiving and backups

#### Object storage

- S3 compatible object storage via [Minio](https://min.io/) - http://192.168.1.4:9002/browser

## NUC

[Hardware](hardware/nuc/README.md)

### Apps

- **Ad Block / DNS** - [PiHole](https://pi-hole.net/) - http://192.168.1.2/admin
- **VPN** - [PiVPN](https://pivpn.io/) ([Wireguard](https://www.wireguard.com/)) - 192.168.1.33
- **Git** - [Gitea](https://about.gitea.com/) - http://192.168.1.211:3000
- **RSS** - [FreshRSS](https://https://www.freshrss.org/) - http://192.168.1.10:8080
- **Dashboard** [Homepage](https://gethomepage.dev) - http://192.168.1.10:3000
- **Recipe Management** [Mealie](https://mealie.io) - http://192.168.1.10:9000
- **Databases** - [MySQL](https://www.mysql.com/) and [Postgres](https://www.postgresql.org/)
- **Movies & TV** - [Jellyfin](https://jellyfin.org/) - http://192.168.1.6:8096
- **Ingress** - [Caddy](https://caddyserver.com/) - 192.168.1.9

## DeskPi

[Hardware](hardware/deskpi/README.md)

### Apps

- **Uptime** - [Uptime Kuma](https://uptime.kuma.pet/) - http://192.168.1.133:3001

## Network

### Internet

500 Mbps Fibre

### DNS

[Pi-hole](https://pi-hole.net/) running on an Ubuntu LXC container in Proxmox on the Intel NUC.

It also blocks adverts.

### LAN

[Ubiquiti Flex 10 GbE](https://techspecs.ui.com/unifi/switching/unifi-flex-xg?s=uk)

[TP-Link Managed Network Switch 8 Port Gigabit](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/)

[D-Link Mesh](https://eu.dlink.com/uk/en/products/m15-eagle-pro-ai-ax1500-mesh-system) setup in bridge mode.

### VPN

[Wireguard](https://www.wireguard.com/) installed on an Ubuntu Server VM in Proxmox on the Intel NUC.
