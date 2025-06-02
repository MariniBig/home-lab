# NAS - Servidor de Armazenamento

Este documento descreve a composição de hardware e função do NAS principal do Home Lab.

## 💼 Função
Servidor de arquivos, armazenamento de backups, containers, VMs leves e compartilhamento de mídia.

## 🧱 Especificações de Hardware

- **Gabinete:** Jonsbo N4
- **Placa-mãe:** ASUS TUF GAMING B760M-PLUS WIFI II, Intel, DDR5
- **Processador:** Intel Core i5 14400F (14ª Geração, 10 núcleos, 16 threads, até 4.7 GHz)
- **Memória RAM:** 64GB DDR5 Corsair Vengeance (2x32GB, 5200MHz, CL40)
- **Fonte:** Corsair SF-L Series SF1000L (1000W, 80 Plus Gold, Modular)
- **Placa de Vídeo:** NVIDIA Quadro T400 (PNY, 4GB GDDR6, PCIe 3.0)
- **HBA:** H1110 81Y4494 SAS-2 ROKE (ZFS, FreeNAS, unRAID, RAID Expansor)
- **PCI-E RJ45:** RTL8125B 2.5Gbps expasion card

## 💾 Armazenamento

- **5x HDD 3TB** 2x WD-Purple, 2x Seagate Barracuda, 1x Toshiba
- **2x SDD 480GB** Kingston Enterprise
- **3x NVME 240GB** Kingston

## 📡 Conectividade

- Conectado via cabo de rede 5 Gbps ao switch TP-Link SG3428 - Link Aggregation, 2x 2.5Gbps
- Acesso via VLAN INFRA (192.168.20.0/24)

## 🔧 Sistema Operacional

*Proxmox*

## 🔐 Observações

- Monitoramento de saúde dos discos via SMART.
- Monitoramento de vms, uso de cpu, memoria via Grafana.
