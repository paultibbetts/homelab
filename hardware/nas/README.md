# NAS

Provides storage and a few core apps.

## Hardware

- **Case** - [Fractal Meshify 2](https://www.fractal-design.com/products/cases/meshify/meshify-2-dark-tempered-glass/black/)
- **MOBO** - [ASRock Rack E3C236D4U](https://www.asrockrack.com/general/productdetail.asp?Model=E3C236D4U#Specifications)
- - **NIC** - 1GbE
- - **NIC** - [Intel Dual Port PCIe 10GbE Server/Workstation Ethernet Network Adapter X540T2BLK OEM](https://www.scan.co.uk/products/2-port-intel-x540-t2-10-gigabit-server-workstation-pcie-x8-ethernet-card-oem)
- - **NVME Adapter** - [Sabrent EC-P3X4 4-Drive NVMe SSD to PCIe 3.0 Adapter Card](https://sabrent.com/products/ec-p3x4)
- **CPU** - [Intel Xeon CPU E3-1270 v5 @ 3.60GHz](https://ark.intel.com/content/www/us/en/ark/products/88174/intel-xeon-processor-e31270-v5-8m-cache-3-60-ghz.html)
- **CPU Cooler** - [Noctua NH-U12S](https://noctua.at/en/nh-u12s)
- **RAM** - [Timetec 16GB DDR4 2400 CL17 Unbuffered ECC](https://www.timetecinc.com/shop/server-memory/timetec-16gb-ddr4-2400-server-memory-2/) x 2 (32GB)
- **PSU** - [Corsair RM650X](https://www.corsair.com/uk/en/Categories/Products/Power-Supply-Units/Power-Supply-Units-Advanced/RMx-Series/p/CP-9020178-UK)

### Storage

#### Boot

1 x [Kingston SSDNow A400 240GB SATA 3 SSD](https://www.buykingston.co.uk/kingston-240gb-ssdnow-a400-ssd-solid-state-drive-2.5-inch-7mm/)

**Total** 240GB

#### SSD

1 x [Samsung 860 EVO 500GB](https://www.samsung.com/uk/memory-storage/sata-ssd/860-evo-sata-3-msata-ssd-500gb-mz-m6e500bw/)

**Total** 500GB

#### HDD

4 x [Seagate IronWolf 6TB NAS 3.5" SATA HDD](https://www.scan.co.uk/products/6tb-seagate-ironwolf-st6000vn001-nas-hard-drive-35-hdd-sata-iii-6gb-s-5400rpm-256mb-cache)

**Total** 24TB

#### NVME

2 x [2TB Crucial P3 M.2 (22x80) PCIe 3.0 (x4) NVMe SSD, 3D NAND, Read 3500MB/s, Write 3000MB/s](https://www.scan.co.uk/products/2tb-crucial-p3-m2-22x80-pcie-30-x4-nvme-ssd-tlc-3d-nand-read-3500mb-s-write-3000mb-s)

**Total** 4TB

## Software

[TrueNAS Scale](https://www.truenas.com/truenas-scale/)

### RAID

#### nvme-storage

Fast Pool.

Raw storage: 4TB

RAID: 2 x disk

Usable storage: 4TB

#### ssd-storage

System Dataset Pool.

Raw storage: 500GB

RAID: N/A

Usable storage: 500GB

#### hdd-storage

Raw storage: 24TB

RAID: RAIDZ2

Usable storage: 12TB
