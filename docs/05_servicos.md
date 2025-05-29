# Serviços Rodando

(Listar serviços como Pi-hole, Home Assistant, VMs, containers, etc.)


Zabbix/Telegraf Pi-Hole
apt install telegraf
curl -sL https://raw.githubusercontent.com/pi-hole/pi-hole/master/advanced/telegraf.conf | sudo tee /etc/telegraf/telegraf.d/pihole.conf