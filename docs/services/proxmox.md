# 🖥️ Proxmox VE - Instalação Padronizada

## 1️⃣ **Pré-Instalação**
### Requisitos Mínimos
- **Hardware**: CPU x64 com virtualização, 8GB RAM, SSD 128GB+
- **Rede**: IP estático, gateway e DNS configurados
- **ISO**: [Proxmox VE 8.1](https://www.proxmox.com/en/downloads) (verifique SHA256)

### Preparação da Mídia
```bash
# Linux (dd)
dd if=proxmox-ve_8.1.iso of=/dev/sdX bs=4M status=progress

# Windows (Rufus)
1. Selecione ISO → Modo DD → Iniciar
```

---

## 2️⃣ **Instalação**
### Passo a Passo
1. **Boot** no dispositivo (USB/ISO)
2. **Selecione disco** (ZFS para SSDs, ext4 para HDDs)
3. **Configure rede**:
   - Hostname: `proxmox-01`
   - IP: `192.168.1.10/24`
   - Gateway: `192.168.1.1`
4. **Defina senha root** e e-mail

---

## 3️⃣ **Pós-Instalação Padrão**
### Script Automatizado ([Fonte](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install))
```bash
wget -O post-install.sh https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install
chmod +x post-install.sh
nano post-install.sh  # Revise as configurações!
./post-install.sh
```

### 🔧 **Customizações Obratórias**
Edite o script para:
```bash
# Variáveis recomendadas:
DISABLE_SUBSCRIPTION_POPUP="true"
OPTIMIZE_ZFS="true"
INSTALL_FAIL2BAN="true"
```

---

## 4️⃣ **Configuração de Cluster**
### Em Todos os Nós
```bash
# Nó Master:
pvecm create cluster-name

# Nós Adicionais:
pvecm add IP_DO_MASTER
```

### Verificação
```bash
pvecm status
corosync-cmapctl | grep members
```

---

## 5️⃣ **Otimizações Padrão**
### ZFS (SSD/NVMe)
```bash
zfs set compression=lz4 rpool
zfs set atime=off rpool
```

### Kernel
```bash
echo "vm.swappiness=10" >> /etc/sysctl.conf
sysctl -p
```

---

## 6️⃣ **Backup Inicial**
```bash
# Configurações críticas
tar czf /backup/proxmox-config_$(date +%F).tar.gz /etc/pve /etc/network/interfaces
```

---

## ⚠️ **Checklist Pós-Instalação**
- [ ] Teste migração de VMs entre nós
- [ ] Configure backup automático (`vzdump`)
- [ ] Atualize todos os nós (`apt update && apt dist-upgrade -y`)

---

## 📌 **Links Úteis**
- [Documentação Oficial](https://pve.proxmox.com/wiki/Main_Page)
- [Tuning ZFS](https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/)