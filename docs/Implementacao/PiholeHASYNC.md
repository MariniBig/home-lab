🔧 Como Implementar
1. Instale os scripts em ambos os nós:
bash
# Crie a pasta de scripts
mkdir -p /usr/local/scripts

# Copie os arquivos (faça em ambos os nós)
scp pihole-ha-sync.sh root@<NODE1>:/usr/local/scripts/
scp pihole-ha-sync.sh root@<NODE2>:/usr/local/scripts/

# Dê permissões
chmod +x /usr/local/scripts/*.sh
2. Configure o CRON para sincronização:
bash
# Adicione esta linha ao crontab (crontab -e)
*/15 * * * * /usr/local/scripts/pihole-ha-sync.sh
3. Configure o systemd para o monitor:
bash
cat > /etc/systemd/system/keepalived-monitor.service <<EOF
[Unit]
Description=Pi-hole HA Monitor
After=keepalived.service

[Service]
ExecStart=/usr/local/scripts/keepalived-monitor.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Habilite o serviço
systemctl daemon-reload
systemctl enable --now keepalived-monitor