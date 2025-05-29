# 🕳️ Pi-hole HA (Keepalived + Dual Instância)

## 📦 **Pré-requisitos**
- 2x Containers LXC (Proxmox) ou VMs
- 1x IP Flutuante (VIP) na mesma rede
- Acesso root em ambos os nós

## 🔧 **Configuração das Instâncias**

### 1. Instale Pi-hole em ambos os nós
```bash
# Nó 1 e Nó 2 (use CTIDs diferentes):
wget https://community-scripts.github.io/ProxmoxVE/scripts?id=pihole -O install_pihole.sh
chmod +x install_pihole.sh
./install_pihole.sh
```

### 2. Defina prioridades (Nó 1 = Master)
| Nó  | IP Fixo     | Prioridade Keepalived |
|-----|-------------|-----------------------|
| Nó1 | 192.168.1.10| 100                   |
| Nó2 | 192.168.1.11| 50                    |

### 3. Instale Keepalived
```bash
# Em ambos os nós:
apt install keepalived -y
```

---

## ⚙️ **Configuração do Keepalived**

### Nó Master (`/etc/keepalived/keepalived.conf`)
```conf
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass pihole-ha
    }
    virtual_ipaddress {
        192.168.1.100/24 dev eth0
    }
}
```

### Nó Backup (`/etc/keepalived/keepalived.conf`)
```conf
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 50
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass pihole-ha
    }
    virtual_ipaddress {
        192.168.1.100/24 dev eth0
    }
}
```

### Inicie o serviço
```bash
systemctl enable --now keepalived
```

---

## 🛡️ **Script de Monitoramento (Opcional)**
Crie `/usr/local/bin/check_pihole.sh` em ambos os nós:
```bash
#!/bin/bash
if ! pidof pihole-FTL >/dev/null; then
    systemctl stop keepalived
fi
```
Permissão:
```bash
chmod +x /usr/local/bin/check_pihole.sh
```

Adicione ao keepalived.conf:
```conf
vrrp_script chk_pihole {
    script "/usr/local/bin/check_pihole.sh"
    interval 2
    weight -50
}
```

---

## 🔍 **Verificação**
```bash
# No nó master:
ip addr show eth0 | grep "192.168.1.100"

# Teste de failover:
systemctl stop pihole-FTL  # No master, o VIP deve migrar
```

---

## 🌐 **Configuração Final**
1. **No seu roteador/DHCP**:  
   Defina o VIP (`192.168.1.100`) como DNS primário.

2. **Sincronize listas**:  
   Use `rsync` para `/etc/pihole` entre os nós.

3. **Monitore**:  
   ```bash
   watch -n 1 'curl -s http://192.168.1.100/admin/version.php | jq'
   ```

---

### ⚠️ **Troubleshooting**
| Problema                | Solução                          |
|-------------------------|----------------------------------|
| VIP não migra           | Verifique `journalctl -u keepalived` |
| Pi-hole para de responder | Teste manualmente: `pihole restartdns` |

---

### 📌 **Dicas de Otimização**
- **Sincronização automática**:  
  Use `inotifywait` para espelhar mudanças em `/etc/pihole` entre nós.

- **Backup**:  
  ```bash
  # Em um dos nós:
  tar czf /backup/pihole-ha_$(date +%F).tar.gz /etc/pihole /etc/unbound
  ```

⚠️ Importante
Configure SSH sem senha entre os nós:

bash
ssh-keygen -t ed25519
ssh-copy-id root@<NODE_OPOSTO>
Revise os paths caso use LXC (adapte eth0 para o interface correto).