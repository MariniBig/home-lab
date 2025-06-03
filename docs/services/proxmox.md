Primeira coisa a fazer é obter a iso do Proxmox e criar o dispositivo de instalação.

Acesse o site do proxmox, em: https://www.proxmox.com/en/
   - Va em Downloads, em Latest Releases, e selecione o donwload que você quer.
   - No meu caso é o Proxmox VE 8.4 ISO Installer, desse link: https://enterprise.proxmox.com/iso/proxmox-ve_8.4-1.iso
Depois disso, você precisa de uma ferramenta para criar o inicializavel, e um disco para isso.
   - Para disco eu usei um pendrive de 64gb, mas provavelmente qualquer disco de 4-8gb deve ser suficiente.
   - Baixar um programa pra gravar a iso no disco, eu uso o Rufus: https://rufus.ie/pt_BR/
   - Criar o disco de instalação, todo processo deve levar no maximo 5 minutos, tudo vai depender da sua conexão com a internet e da velocidade do sistema.
Proximo passo é conectar o pendrive de instalação no computador que voce pretende instalar o Proxmox, e ligar o mesmo.
   - Você precisa acessar a BIOS, para ativar a virtualização e para selecionar o pendrive como disco de incialização, geralmente é DEL ou F12, mas isso pode variar de maquina pra maquina. Pra mim é F12.
   - Nessa BIOS, dentro de CPU Configuration, tem a configuração "Intel (VMS) Virtualization Technology" e eu selecionei Enable, e na parte de Boot, coloquei o Pendrive como proximo boot.
   - A instalação é simples e pratica, só seguir o que fala nas telas, mas o que eu selecionei é:
      - Install Proxmox VE (Graphical)
      - Aceitei a licença de uso
      - Selecionei o disco SSD de 480GB, para instalação do Proxmox, aqui é onde você faz a configuração de mirror pra instalação se quiser, não vai ser o caso desse computador
      - Digitar o pais, Brazil, a Time zone, America/Sao_Paulo, e Brazil-Portuguese no layout do teclado
      - Defini a senha do servidor, pode ser encontrada no arquivo "senhas" e coloquei o e-mail: marini@dumar.log.br
      - Não mudei a interface de rede, mas dei um nome: pve.marini.home e um ip fixo: 192.168.0.200/24, coloquei o gateway: 192.168.0.1 e o DNS: 192.168.0.1
      - Em seguida ele tras um resumo da instalação, se estiver tudo certo clicar em Install
      - Conforme ele for reiniciando, remover o pendrive.
Em seguida vamos acessar via WebUI a instalação.
   - No meu caso vai ser: https://192.168.0.200:8006/
   - Digitar o usuario: root
   - Digitar a senha criada anteriormente
A primeira coisa que eu faço ao instalar o proxmox é executar um script da comunidade, que pré configura algumas coisas.
   - Nesse link você pode pegar o script: https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install
   - Esse é o script: bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
   - Abra o "Shell", clique com o botão direito do mouse e clique em colar e aperte Enter
   - Vai aparecer pra selecionar se tu quer iniciar o script, aperte Y e Enter
   - A primeira seleção é pra corrigir as fontes de atualização e instalação do Proxmox, selecionei Yes
   - A segunda vai desabilitar o repositório Enterprise, se você não tem assinatura do Proxmox, selecionei Yes
   - A terceira vai habilitar o repositório para você que não é inscrito, selecionei Yes
   - A quarta é se você vai selecionar o ceph, pra habilitar os dois repositórios, aqui selecionei No
   - Se você vai fazer testes das novas versões e ferramentas do Proxmox, eu não vou então selecionei No
   - Nessa parte você habilita ou desabilita alta disponibilidade, se você vai ter mais que um servidor Proxmox, e vai ter VMs que podem trocar de um pro outro, selecione pra habilitar, se não, pode desabilitar, vou deixar habilitado
   - Agora ele vai pedir se voce quer atualizar o sistema agora, e eu coloquei que sim
   - Terminando tudo ele vai pedir pra reiniciar o sistema, e tambem selecionei sim.
