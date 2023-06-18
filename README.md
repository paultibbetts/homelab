# Homelab

An overview of my homelab.

## Server

NAS

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

### DNS

[Pi-hole](https://pi-hole.net/) running on a [Raspberry Pi 1](https://www.raspberrypi.com/products/raspberry-pi-1-model-b-plus/).

It also blocks adverts.

Pi-hole manages the DNS for the homelab with a Dnsmasq entry:

```
# /etc/dnsmasq.d/02-homelab.conf
address=/cloud.paultibbetts.uk/192.168.1.4
```

This needed a restart with `pihole restartdns`.

### LAN

 [TP-Link Managed Network Switch 8 Port Gigabit](https://www.tp-link.com/uk/business-networking/easy-smart-switch/tl-sg108e/)

 ### Internet

 [Devolo Magic 2 LAN Powerline adapter](https://www.devolo.co.uk/magic-2-lan)