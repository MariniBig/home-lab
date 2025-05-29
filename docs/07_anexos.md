# Anexos e Diagramas

(Adicionar diagramas da rede e fotos do setup físico.)

📌 Dicas para NAS
Performance:

Use NFS em vez de CIFS para mounts

Adicione cache no container:

conf
mp0: /mnt/nas/media,mp=/media,cache=writeback
Monitoramento:

bash
# Instale netdata no container:
wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh

🔧 Integração com Seu Homelab
Reverse Proxy: Configure Nginx/Apache para acesso externo seguro

Backup Automático: Agende no Proxmox:

bash
echo "0 3 * * * root vzdump <CTID> --mode stop --storage backup-nas" >> /etc/crontab