#!/bin/bash
# JELLYFIN POST-INSTALL SCRIPT
# Uso: Executar DENTRO do container após instalação

# 1. Otimiza FFmpeg
cat > /etc/ffmpeg/ffmpeg.conf <<EOF
[vaapi]
hwaccel=vaapi
hwaccel_device=/dev/dri/renderD128
EOF

# 2. Configura bibliotecas padrão
mkdir -p /media/{Movies,TVShows,Music}
chown -R jellyfin:jellyfin /media

# 3. Reinicia serviços
systemctl restart jellyfin

echo -e "\n\e[32m✔ Configuração concluída!\e[0m"
echo "Acesse: http://$(hostname -I | awk '{print $1}'):8096"