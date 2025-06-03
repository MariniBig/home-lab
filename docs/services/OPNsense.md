Primeira coisa a fazer é baixar a iso e colocar no repositorio do Proxmox.
    - Existe a possibilidade de usar um script da comunidade, porem para o roteador eu prefiro fazer manualmente
    - O site é: https://opnsense.org/
    - Clique em Download OPNsense
    - Selecione a arquitetura (amd64), o tipo de imagem (dvd), e a localização do mirror (Cloudfence - Brazil)
    - Clicar em Download OPNsense
    - Assim que terminar de baixar, extrair o arquivo em uma pasta de sua escolha
    - Na WebUI do proxmox, clique em datacenter/pve/local (pve) - no meu caso, aonde PVE é o nome do meu computador, e LOCAL (PVE) é o nome de onde ficam as isos.
    - Clique em ISO Images, Upload, Select File, navegue até aonde você extraiu a imagem do OPN e selecione, clique em Upload.
Assim que concluir, antes de iniciar as instalações, vamos criar as duas interfaces de rede pro sistema usar.
    - Como meu minipc tem 4 saidas de rede, vamos utilizar duas, uma pra WAN e uma pra LAN.
    - Clique em "PVE", "Network", em "Create" e em "Linux Bridge"
    - Eu vou criar a "vmbr1" na porta "enp4s0" e de comentario colocar "WAN"
    - Eu vou criar a "vmbr2" na porta "enp3s0" e de comentario colocar "LAN" e marcar "VLAN aware"
Após ter feito isso, podemos iniciar a criação da VM.
    - Clicar em "Create VM"
    - Para o roteador vou usar a VM ID "254" pois o ip sera 192.168.0.254
    - O nome eu coloquei OPNsense
    - Tags: router
    - Marcar "Advanced" e clicar em "Next"
    - Selecionar a ISO e clicar em "Next"
    - Na aba "System" eu só troquei o "Machine" pra q35
    - Disk size diminui pra 8gb
    - Aumentei para 2 cores e em "aes" marquei ON
    - Para memoria marquei 4096, porem coloquei de minimo 2048
    - Selecionei a VMBR1, e cliquei em next, nossa porta WAN
    - Desmarquei o "Start after created", pois quero adicionar a outra porta LAN antes de inciciar
    - Cliquei em "Finish"
    - Cliquei na VM "254 (OPNsense), e em Hardware, em Add, Network Device, e selecionei a VMBR2.
Agora podemos iniciar ela, que vai iniciar a instalação