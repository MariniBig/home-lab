#!/bin/bash
# PI-HOLE HA SYNC SCRIPT
# Uso: Executar em AMBOS os nós (via cron)
# Sincroniza listas e configurações entre nós

# ===== CONFIGURÁVEIS =====
NODE1_IP="192.168.1.10"    # Substitua pelo IP do Nó 1
NODE2_IP="192.168.1.11"    # Substitua pelo IP do Nó 2
VIP="192.168.1.100"         # IP flutuante
SYNC_DIRS=("/etc/pihole" "/etc/unbound")  # Pastas a sincronizar
LOG_FILE="/var/log/pihole-ha.log"

# ===== FUNÇÕES =====
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

sync_files() {
  local remote_node=$1
  for dir in "${SYNC_DIRS[@]}"; do
    rsync -az --delete --exclude '*.db' -e "ssh -o StrictHostKeyChecking=no" "$remote_node:$dir/" "$dir/" && \
    log "Sincronizado: $dir de $remote_node" || \
    log "ERRO ao sincronizar $dir de $remote_node"
  done
}

check_vip() {
  ip addr show eth0 | grep -q "$VIP"
}

# ===== LÓGICA PRINCIPAL =====
log "Iniciando sincronização..."

# Se este nó tem o VIP, é o master
if check_vip; then
  log "Este nó é MASTER ($VIP)"
  # Sincroniza do master para o backup
  sync_files "$NODE2_IP"
else
  log "Este nó é BACKUP"
  # Sincroniza do backup para o master
  sync_files "$NODE1_IP"
fi

# Reinicia serviços se necessário
if [ -f "/tmp/pihole-sync-restart" ]; then
  systemctl restart pihole-FTL unbound
  rm -f "/tmp/pihole-sync-restart"
  log "Serviços reiniciados"
fi

log "Sincronização concluída"