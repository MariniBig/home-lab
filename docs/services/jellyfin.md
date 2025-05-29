# 🎬 Jellyfin no NAS - Instalação Automatizada

## 📥 Instalação via Script Proxmox
```bash
# Execute no node do NAS (via SSH ou console Proxmox)
wget https://community-scripts.github.io/ProxmoxVE/scripts?id=jellyfin -O install_jellyfin.sh
chmod +x install_jellyfin.sh
./install_jellyfin.sh
```

### 🔍 **O que o script faz?**
1. Cria um container LXC (Debian 12)
2. Instala:
   - Jellyfin (latest)
   - FFmpeg (com suporte a GPU)
   - Drivers Intel QuickSync (se detectado)
3. Configura:
   - Pasta `/mnt/storage/media` como biblioteca
   - Usuário `media` com permissões adequadas

---

## ⚙️ **Pós-Instalação**

### 1. Acesse a WebUI
```
http://<IP_DO_CONTAINER>:8096
```

### 2. Monte o Armazenamento do NAS
Edite `/etc/pve/lxc/<CTID>.conf` e adicione:
```conf
mp0: /mnt/nas/media,mp=/media
```

### 3. Otimizações para Hardware
#### Para Intel QuickSync (iGPU):
```bash
# Dentro do container:
apt install intel-media-va-driver-non-free -y
echo 'LIBVA_DRIVER_NAME=iHD' >> /etc/environment
```

#### Para NVIDIA:
```bash
# No host Proxmox:
apt install nvidia-driver nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=containerd
```

---

## 🛠️ **Configurações Recomendadas**

### 1. Bibliotecas
```bash
# Exemplo de estrutura de pastas:
/mnt/nas/media/
├── Movies
├── TV Shows
└── Music
```

### 2. Transcoding
Edite `/etc/jellyfin/system.xml`:
```xml
<HardwareAcceleration>vaapi</HardwareAcceleration>
<VaapiDevice>/dev/dri/renderD128</VaapiDevice>
```

### 3. Backup
```bash
# Script de backup (no host Proxmox):
vzdump <CTID> --mode snapshot --compress zstd --storage <STORAGE_ID>
```

---

## ⚠️ **Troubleshooting**
| Problema                | Solução                          |
|-------------------------|----------------------------------|
| "Acesso negado" às pastas | Execute no container: `chown -R jellyfin:jellyfin /media` |
| Transcoding não funciona | Verifique drivers: `vainfo` |
| Container não inicia    | Confira `journalctl -u pve-container@<CTID>` |

---

## 🔄 **Atualização**
```bash
# Dentro do container:
apt update && apt upgrade jellyfin -y
systemctl restart jellyfin
```


🛠️ Como Implementar
1. Execute o script principal:
bash
./install_jellyfin.sh
2. Após instalação, dentro do container:
bash
./jellyfin-postinstall.sh
3. No host Proxmox (NAS):
bash
# Crie mount points (ajuste para seu storage)
mkdir -p /mnt/nas/media
chmod 775 /mnt/nas/media

### 🎮 Configuração para NVIDIA T400
#### 1. No host Proxmox (NAS):
```bash
# Instale drivers e toolkit
apt install -y nvidia-driver-525 nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=containerd
systemctl restart containerd

# Verifique a GPU
nvidia-smi  # Deve mostrar sua T400
```

#### 2. Passe a GPU para o container:
Edite `/etc/pve/lxc/<CTID>.conf` e adicione:
```conf
lxc.cgroup2.devices.allow: c 195:* rwm
lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file
```

#### 3. Dentro do container:
```bash
# Instale pacotes necessários
apt install -y ffmpeg nvidia-cuda-toolkit

# Configure o Jellyfin
cat > /etc/jellyfin/system.xml <<EOF
<HardwareAcceleration>nvenc</HardwareAcceleration>
<EncoderAppPath>/usr/bin/ffmpeg</EncoderAppPath>
<VaapiDevice>/dev/dri/renderD128</VaapiDevice>
<NvEncDevice>0</NvEncDevice>
EOF
```

#### 4. Reinicie o serviço:
```bash
systemctl restart jellyfin
```

#### 🔍 Verifique o encoding:
```bash
ffmpeg -hide_banner -hwaccels  # Deve listar "cuda" e "nvenc"
```

---

### 📂 **Script Atualizado: `scripts/jellyfin-postinstall.sh`**
Substitua pelo seguinte conteúdo:
```bash
#!/bin/bash
# JELLYFIN POST-INSTALL (NVIDIA T400)
echo "▶ Configurando NVIDIA T400..."

# 1. Instala dependências
apt update
apt install -y ffmpeg nvidia-cuda-toolkit

# 2. Cria arquivo de configuração do FFmpeg
cat > /etc/ffmpeg/ffmpeg.conf <<EOF
[hwaccel]
hwaccel=cuda
hwaccel_device=0

[nvenc]
init_hw_device=cuda:0
EOF

# 3. Configura bibliotecas
mkdir -p /media/{Movies,TVShows,Music}
chown -R jellyfin:jellyfin /media

# 4. Reinicia serviços
systemctl restart jellyfin

echo -e "\n\e[32m✔ NVIDIA T400 configurada!\e[0m"
echo "Teste o transcoding com:"
echo "ffmpeg -i input.mp4 -c:v h264_nvenc -preset p7 -tune hq -b:v 10M output.mp4"
```

---

### ⚙️ **Passos para Implementação**

#### 1. No host Proxmox (NAS):
```bash
# Pare o container antes de editar
pct stop <CTID>

# Edite a configuração
nano /etc/pve/lxc/<CTID>.conf
# Cole as linhas de mount da GPU mostradas acima

# Inicie o container
pct start <CTID>
```

#### 2. Dentro do container:
```bash
# Execute o script de pós-instalação
./jellyfin-postinstall.sh

# Verifique a GPU
nvidia-smi  # Deve funcionar dentro do container
```

---

### 🛠️ **Troubleshooting (NVIDIA Específico)**

| Problema                 | Solução                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| "NVIDIA-SMI has failed"  | Verifique se o kernel do host tem os módulos NVIDIA carregados: `lsmod \| grep nvidia` |
| Erro de permissão        | Adicione no `/etc/pve/lxc/<CTID>.conf`: `lxc.cgroup2.devices.allow: c 195:* rwm` |
| Codec não disponível     | Atualize drivers: `apt install nvidia-driver-535` (versão mais nova)    |

---

### 🎬 **Configurações Recomendadas no Jellyfin**
1. **Dashboard → Transcoding**:
   - Habilitar: **Hardware Acceleration**
   - Seletor: **NVIDIA NVENC**
   - Configurações avançadas:
     - **Preset**: P7 (para T400)
     - **Rate Control**: VBR
     - **B-Frames**: 3

2. **Bibliotecas**:
   - Defina `/media` como caminho raiz
   - Use metadados **embedded** para melhor desempenho

---

### 📌 **Dica de Performance**
Para otimizar sua T400 (4GB GDDR6), limite sessões concorrentes:
```bash
# No container:
echo "MAX_SESSIONS=3" >> /etc/jellyfin/conf.d/nvidia.conf
```

Isso evita sobrecarga da GPU em transcode simultâneos.
