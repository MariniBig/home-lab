# Caminho do repositório
$REPO_PATH = "C:\Users\Felipe\Documents\GitHub\home-lab"

# Criar estrutura de pastas
New-Item -Path "$REPO_PATH\docs\services" -ItemType Directory -Force
New-Item -Path "$REPO_PATH\docs\images" -ItemType Directory -Force
New-Item -Path "$REPO_PATH\ansible\roles\nginx\tasks" -ItemType Directory -Force
New-Item -Path "$REPO_PATH\ansible\roles\nginx\templates" -ItemType Directory -Force
New-Item -Path "$REPO_PATH\terraform\modules" -ItemType Directory -Force

# Criar arquivo _index.md
@"
# 📚 Documentação do Homelab

## 🏠 Visão Geral
- [Objetivos](/docs/overview.md)
- [Hardware & Serviços](/docs/inventory.md)

## 🌐 Rede
- [Topologia](/docs/networking.md)
- [Firewall](/docs/networking.md#firewall)

## 🛠 Serviços
- [Pi-hole](/docs/services/pihole.md)
- [Proxmox](/docs/services/proxmox.md)
"@ | Out-File -FilePath "$REPO_PATH\docs\_index.md" -Encoding utf8

Write-Output "✅ Estrutura criada em: $REPO_PATH"