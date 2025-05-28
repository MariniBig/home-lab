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

## 💾 Armazenamento

- **5x HDD 3TB** (marcas variadas)
- **2x SSD 480GB Kingston Enterprise**
- **3x NVMe 240GB Kingston**

## 📡 Conectividade

- Conectado via cabo de rede 2.5 Gbps ao switch TP-Link SG3428
- Acesso via VLAN INFRA (192.168.20.0/24)

## 🔧 Sistema Operacional

*(Adicionar posteriormente: TrueNAS Scale, Proxmox, Unraid ou outro utilizado)*

## 🔐 Observações

- Backups automáticos para volume separado.
- Monitoramento de saúde dos discos via SMART.
