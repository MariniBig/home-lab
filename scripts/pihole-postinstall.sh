#!/bin/bash
# PI-HOLE POST-INSTALL SCRIPT
# Uso: Executar DENTRO do container LXC após instalação

# 1. Configura Firebog
wget -O /usr/local/bin/pihole-updatelists https://raw.githubusercontent.com/jacklul/pihole-updatelists/master/pihole-updatelists.sh
chmod +x /usr/local/bin/pihole-updatelists

# 2. Listas recomendadas
cat > /etc/pihole-updatelists.conf <<EOF
ADLISTS_URL="https://v.firebog.net/hosts/lists.php?type=tick"
WHITELIST_URL="https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt"
EOF

# 3. Atualiza tudo
pihole-updatelists
pihole restartdns

echo -e "\n\e[32m✔ Configuração concluída!\e[0m"
echo "Acesse: http://$(hostname -I | awk '{print $1}')/admin"