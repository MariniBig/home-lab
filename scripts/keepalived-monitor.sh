#!/bin/bash
# KEEPALIVED MONITOR SCRIPT
# Verifica saúde do Pi-hole e força failover se necessário

# ===== CONFIGURÁVEIS =====
PIHOLE_PORT=80
CHECK_INTERVAL=5
FAIL_COUNT=3

# ===== MONITORAMENTO =====
count=0
while true; do
  if ! nc -z localhost "$PIHOLE_PORT"; then
    ((count++))
    echo "[$(date)] Pi-hole não responde (tentativa $count/$FAIL_COUNT)" >> /var/log/keepalived-monitor.log
    if [ "$count" -ge "$FAIL_COUNT" ]; then
      echo "[$(date)] Forçando failover!" >> /var/log/keepalived-monitor.log
      systemctl stop keepalived
      exit 1
    fi
  else
    count=0
  fi
  sleep "$CHECK_INTERVAL"
done