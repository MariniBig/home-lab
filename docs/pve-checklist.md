# ✅ Checklist Pós-Instalação Proxmox VE

## 🔧 Configuração Básica
- [ ] Script pós-instalação executado (`/scripts/post-install.sh`)
- [ ] Hostname e IP estático configurados
- [ ] Repositórios verificados (`/etc/apt/sources.list.d/pve-enterprise.list`)

## 🌐 Cluster (Se Aplicável)
- [ ] Todos os nós respondem ao `pvecm status`
- [ ] Corosync configurado (`/etc/pve/corosync.conf`)
- [ ] Teste de migração manual executado

## 🛡️ Segurança
- [ ] Fail2Ban ativo (`systemctl status fail2ban`)
- [ ] Porta Web alterada (opcional, via `/etc/default/pveproxy`)
- [ ] Certificado SSL válido

## 💾 Armazenamento
- [ ] ZFS otimizado (se usado):
  ```bash
  zfs get compression,atime rpool
  ```
- [ ] Storage compartilhado adicionado (NFS/CIFS/iSCSI)

## 🔄 Backup Inicial
- [ ] Configurações exportadas:
  ```bash
  tar czf /backup/proxmox-config_$(date +%F).tar.gz /etc/pve
  ```
- [ ] Agendamento de backups configurado

## 📊 Monitoramento
- [ ] Email de notificação configurado (WebUI: Datacenter → Options)
- [ ] Grafana+Prometheus instalados (opcional)

> **Última Verificação**: $(date +%F)