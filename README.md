# Homelab

An overview of my homelab.

## NAS 

[Hardware](/hardware/nas/README.md)

### Apps

- **Books** - [Calibre](https://calibre-ebook.com/) + [Calibre Web](https://github.com/janeczku/calibre-web) - https://books.cloud.paultibbetts.uk
- **Dashboard** - [Heimdall](https://heimdall.site/) - https://apps.cloud.paultibbetts.uk
- **Games** - [EmulatorJS](https://github.com/ethanaobrien/emulatorjs) - https://games.cloud.paultibbetts.uk
- **Git** - [Gitea](https://gitea.io/en-us/) - https://git.cloud.paultibbetts.uk
- **Ingress** - [Traefik](https://traefik.io/)
- **Media** - [Jellyfin](https://jellyfin.org/) - https://media.cloud.paultibbetts.uk

### TLS

Used [Truecharts clusterissuer](https://truecharts.org/charts/enterprise/clusterissuer/) to add a wildcard Let's Encrypt certificate for `cloud.paultibbetts.uk`.

## NUC

[Hardware](/hardware/nuc/README.md)
### Apps

- **Ad Block / DNS** - [PiHole](https://pi-hole.net/) - http://192.168.1.2/admin
- **VPN** - [PiVPN](https://pivpn.io/) ([Wireguard](https://www.wireguard.com/)) - 192.168.1.8

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

[TP-Link Managed Network Switch 8 Port Gigabit](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/)

[D-Link Mesh](https://eu.dlink.com/uk/en/products/m15-eagle-pro-ai-ax1500-mesh-system) setup in bridge mode.

### VPN

[Wireguard](https://www.wireguard.com/) installed on an Ubuntu Server VM in Proxmox on the Intel NUC.