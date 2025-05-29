# 🕳️ Pi-hole + Unbound (Instalação Automatizada)

## 📥 Instalação via Script Proxmox
```bash
# Baixe e execute o script oficial
wget https://community-scripts.github.io/ProxmoxVE/scripts?id=pihole -O install_pihole.sh
chmod +x install_pihole.sh
./install_pihole.sh
```

### 🔍 **O que o script faz?**
1. Cria um LXC container dedicado (Debian 12)
2. Instala:
   - Pi-hole (latest)
   - Unbound (DNS recursivo)
   - Cloudflared (DoH opcional)
3. Configura:
   - Unbound na porta `5335`
   - Firewall básico
   - Logrotate

## 🌐 Pós-Instalação
### 1. Acesse o WebUI
```
http://<IP_DO_CONTAINER>/admin
```
- Senha inicial: Verifique o output do script ou execute:
  ```bash
  pct exec <CTID> -- sudo cat /etc/pihole/setupVars.conf | grep WEBPASSWORD
  ```

### 2. Configure Unbound
Arquivo principal:  
`/etc/unbound/unbound.conf.d/pi-hole.conf`  
```yaml
server:
  # Configurações padrão do script:
  port: 5335
  do-ip4: yes
  do-ip6: no  # Desativado por padrão
```

### 3. Adicione Listas de Bloqueio (Firebog)
```bash
# Dentro do container LXC:
wget https://raw.githubusercontent.com/jacklul/pihole-updatelists/master/install.sh
chmod +x install.sh
./install.sh

# Configure atualização diária:
sudo crontab -e
```
Adicione:  
`0 3 * * * /usr/local/bin/pihole-updatelists`

## ⚙️ Otimizações Recomendadas
### Para o Container LXC:
```bash
# Ajuste recursos (no host Proxmox):
pct set <CTID> --memory 512 --swap 0 --cores 1
```

### Para o Pi-hole:
```bash
# Habilitar logging compactado:
sed -i 's/log-queries=extra/log-queries=extra log-compressed=yes/' /etc/dnsmasq.d/01-pihole.conf
```

## 🔄 Comandos Úteis
| Função                | Comando                               |
|-----------------------|---------------------------------------|
| Atualizar Pi-hole     | `pihole -up`                          |
| Reiniciar DNS         | `pihole restartdns`                   |
| Verificar Unbound     | `sudo systemctl status unbound`       |
| Logs em tempo real    | `tail -f /var/log/pihole.log`         |

## ⚠️ Troubleshooting
- **Problema**: Unbound não responde  
  **Solução**:  
  ```bash
  sudo unbound-checkconf && sudo systemctl restart unbound
  ```

- **Problema**: Pi-hole não bloqueia  
  **Solução**:  
  Verifique se o DNS está configurado corretamente nos clients:  
  ```bash
  dig example.com @<IP_DO_PIHOLE>
  ```