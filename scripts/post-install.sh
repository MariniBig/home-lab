#!/bin/bash
# PROXMOX POST-INSTALL SCRIPT (PADRONIZADO)
# Baseado em: https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install
# Versão: 1.1 (2024-06-20)

# ===== CONFIGURÁVEIS =====
DISABLE_SUBSCRIPTION_POPUP="true"
OPTIMIZE_ZFS="true"
INSTALL_FAIL2BAN="true"
UPDATE_SYSTEM="true"
CUSTOM_SOURCES="false"  # Altere para true se usar repositórios customizados

# ===== FUNÇÕES =====
header() {
  echo -e "\n\e[34m=== $1 ===\e[0m"
}

# ===== EXECUÇÃO =====
header "1. ATUALIZAÇÃO DO SISTEMA"
if [ "$UPDATE_SYSTEM" = "true" ]; then
  apt update
  apt dist-upgrade -y
  apt autoremove -y
fi

header "2. CONFIGURAÇÕES PADRÃO"
# Remove popup de subscription
if [ "$DISABLE_SUBSCRIPTION_POPUP" = "true" ]; then
  sed -i "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
fi

# Otimiza ZFS
if [ "$OPTIMIZE_ZFS" = "true" ]; then
  zfs set compression=lz4 rpool
  zfs set atime=off rpool
  echo "options zfs zfs_arc_max=1073741824" > /etc/modprobe.d/zfs.conf
fi

header "3. SEGURANÇA"
if [ "$INSTALL_FAIL2BAN" = "true" ]; then
  apt install -y fail2ban
  systemctl enable --now fail2ban
fi

# ===== FINALIZAÇÃO =====
header "CONCLUÍDO"
echo -e "\e[32m✔ Script executado com sucesso!\e[0m"
echo -e "Recomendações:\n- Reinicie o servidor: \e[33mreboot\e[0m\n- Verifique o status do cluster: \e[33mpvecm status\e[0m"