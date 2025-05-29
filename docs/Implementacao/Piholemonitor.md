📌 Como Usar
Instalação Básica:

bash
./install_pihole.sh  # Siga as prompts interativas
Pós-Instalação (dentro do container):

bash
lxc-attach -n <CTID>
./pihole-postinstall.sh
No Proxmox Host:

bash
# Backup do container
vzdump <CTID> --compress zstd --mode snapshot
🔧 Integração com Seu Homelab
No seu roteador/switch:

Configure DHCP para enviar o IP do Pi-hole como DNS primário.

No Proxmox:

Adicione monitoramento via Zabbix/Telegraf:

bash
apt install telegraf
curl -sL https://raw.githubusercontent.com/pi-hole/pi-hole/master/advanced/telegraf.conf | sudo tee /etc/telegraf/telegraf.d/pihole.conf