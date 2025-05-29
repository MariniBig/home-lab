# Checklist de Manutenção

(Listar rotinas de verificação, atualizações, testes de backup, etc.)

Pi-hole
📌 Testes Recomendados
Simule falha no Master:
bash
# No nó master:
systemctl stop pihole-FTL

# Verifique no backup:
tail -f /var/log/keepalived-monitor.log
ip addr show eth0 | grep "$VIP"
Verifique sincronização:
bash
# Modifique uma lista no master:
echo "teste.ha" >> /etc/pihole/blacklist.txt

# Verifique no backup após 15 minutos:
cat /etc/pihole/blacklist.txt | grep "teste.ha"