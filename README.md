# Homelab

An overview of my homelab.

## Intel NUC

Virtualisation and compute.

### Hardware

- **CPU** - [i7 1360P](https://www.intel.com/content/www/us/en/products/sku/233099/intel-nuc-13-pro-kit-nuc13anhi7/specifications.html)
- **RAM** - [64GB 3200MHz Corsair Vengeance SODIMM DDR4](https://www.corsair.com/uk/en/p/memory/cmsx64gx4m2a2933c19/vengeancea-series-64gb-2-x-32gb-ddr4-sodimm-2933mhz-cl19-memory-kit-cmsx64gx4m2a2933c19)
- **NIC** - 2.5GBE

#### Storage

##### Boot

- 1 x [500GB Samsung SSD 870 EVO](https://www.samsung.com/uk/memory-storage/sata-ssd/870-evo-500gb-sata-3-2-5-ssd-mz-77e500b-eu/)

**Total** 500GB

##### SSD

- 1 x [1TB Samsung SSD 980 Pro](https://www.samsung.com/uk/memory-storage/nvme-ssd/980-pro-pcle-4-0-nvme-m-2-ssd-1tb-mz-v8p1t0bw/)

**Total** 1TB

### Software

[Proxmox VE](https://www.proxmox.com/en/proxmox-ve)

### Apps

- **Ad Block / DNS** - [PiHole](https://pi-hole.net/) - http://192.168.1.2/admin
- **VPN** - [PiVPN](https://pivpn.io/) ([Wireguard](https://www.wireguard.com/)) - 192.168.1.8

## NAS

Provides storage and a few core apps.

### Hardware

- **Case** - [Fractal Meshify 2](https://www.fractal-design.com/products/cases/meshify/meshify-2-dark-tempered-glass/black/)
- **MOBO** - [ASRock Rack E3C236D4U](https://www.asrockrack.com/general/productdetail.asp?Model=E3C236D4U#Specifications)
- - **NIC** - 1GBE
- **CPU** - [Intel Xeon CPU E3-1270 v5 @ 3.60GHz](https://ark.intel.com/content/www/us/en/ark/products/88174/intel-xeon-processor-e31270-v5-8m-cache-3-60-ghz.html)
- **CPU Cooler** - [Noctua NH-U12S](https://noctua.at/en/nh-u12s)
- **RAM** - [Timetec 16GB DDR4 2400 CL17 Unbuffered ECC](https://www.timetecinc.com/shop/server-memory/timetec-16gb-ddr4-2400-server-memory-2/) x 2 (32GB)
- **PSU** - [Corsair RM650X](https://www.corsair.com/uk/en/Categories/Products/Power-Supply-Units/Power-Supply-Units-Advanced/RMx-Series/p/CP-9020178-UK)

#### Storage

##### Boot

1 x [Kingston SSDNow A400 240GB SATA 3 SSD](https://www.buykingston.co.uk/kingston-240gb-ssdnow-a400-ssd-solid-state-drive-2.5-inch-7mm/)

**Total** 240GB

##### SSD

1 x [Samsung 860 EVO 500GB](https://www.samsung.com/uk/memory-storage/sata-ssd/860-evo-sata-3-msata-ssd-500gb-mz-m6e500bw/)

**Total** 500GB

##### HDD

4 x [Seagate IronWolf 6TB NAS 3.5" SATA HDD](https://www.scan.co.uk/products/6tb-seagate-ironwolf-st6000vn001-nas-hard-drive-35-hdd-sata-iii-6gb-s-5400rpm-256mb-cache)

**Total** 24TB


### Software

[TrueNAS Scale](https://www.truenas.com/truenas-scale/)

#### RAID

##### ssd-storage

System Dataset Pool.

Raw storage: 500GB

RAID: N/A

Usable storage: 500GB

##### hdd-storage

Raw storage: 24TB

RAID: RAIDZ2

Usable storage: 12TB

#### TLS

Used [Truecharts clusterissuer](https://truecharts.org/charts/enterprise/clusterissuer/) to add a wildcard Let's Encrypt certificate for `cloud.paultibbetts.uk`.

### Apps

- **Books** - [Calibre](https://calibre-ebook.com/) + [Calibre Web](https://github.com/janeczku/calibre-web) - https://books.cloud.paultibbetts.uk
- **Dashboard** - [Heimdall](https://heimdall.site/) - https://apps.cloud.paultibbetts.uk
- **Games** - [EmulatorJS](https://github.com/ethanaobrien/emulatorjs) - https://games.cloud.paultibbetts.uk
- **Git** - [Gitea](https://gitea.io/en-us/) - https://git.cloud.paultibetts.uk
- **Ingress** - [Traefik](https://traefik.io/)
- **Media** - [Jellyfin](https://jellyfin.org/) - https://media.cloud.paultibbetts.uk

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