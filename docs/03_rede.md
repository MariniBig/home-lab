# Rede e Topologia

## Gerenciador

- Omada

## VLANs e Segmentação

| VLAN | Nome        | Faixa IP         | Finalidade                                                                  |
|------|-------------|------------------|-----------------------------------------------------------------------------|
| 10   | MGMT        | 192.168.10.0/24  | Gerenciamento (switch, APs, OPNsense, NVR)                                  |
| 20   | INFRA       | 192.168.20.0/24  | Servidores internos, DNS, DHCP, containers                                 |
| 30   | IOT         | 192.168.30.0/24  | Dispositivos IoT: TVs, Alexa, automação                           |
| 40   | USER        | 192.168.40.0/24  | Dispositivos pessoais: notebooks, PCs, smartphones                         |
| 50   | GUEST       | 192.168.50.0/24  | Wi-Fi para visitantes (somente internet)                                   |
| 60   | CAMERAS     | 192.168.60.0/24  | Câmeras IP conectadas ao NVR                                               |
| 70   | TESTLAB     | 192.168.70.0/24  | VMs e containers de testes e desenvolvimento                               |

## Regras de Acesso (Firewall)

- `MGMT` → acesso total para administração.
- `USER` → acesso controlado ao `INFRA` (DNS, DHCP).
- `IOT` e `CAMERAS` → sem acesso à internet (exceto NTP/DNS), isolados dos usuários.
- `GUEST` → apenas internet, sem acesso interno.
- `TESTLAB` → acesso controlado; sem permissão para `MGMT` e `USER`.

## Considerações

- Serviços DNS e DHCP ficam em `INFRA`, com DHCP relay ativado nas outras VLANs.
- O isolamento de cliente está ativado em `GUEST` pelo controlador Omada.
- QoS pode ser configurado por VLAN se necessário.
