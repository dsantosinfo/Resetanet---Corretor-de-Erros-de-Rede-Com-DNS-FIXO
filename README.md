# Resetanet — Corretor de Erros de Rede com DNS Fixo

Script batch para Windows que automatiza a correção dos problemas mais comuns de conectividade de rede, aplicando DNS fixo e redefinindo as configurações de rede do sistema.

## O que o script faz

1. Verifica se está sendo executado como Administrador
2. Detecta automaticamente o adaptador de rede ativo
3. Define DNS primário **1.1.1.1** (Cloudflare) e secundário **8.8.8.8** (Google)
4. Libera e renova o IP do adaptador (`ipconfig /release` e `/renew`)
5. Limpa o cache DNS (`ipconfig /flushdns`)
6. Reseta o Winsock (`netsh winsock reset`)
7. Reseta a pilha TCP/IP (`netsh int ip reset`)
8. Reseta as regras do Firewall para o padrão do Windows (`netsh advfirewall reset`)
9. Reinicia o serviço DHCP
10. Registra o DNS (`ipconfig /registerdns`)
11. Desabilita e reabilita a interface de rede

## Requisitos

- Windows 10 ou superior
- Windows em **português** (a detecção do adaptador usa o termo "Conectado")
- Permissão de **Administrador**

## Como usar

1. Clique com o botão direito em `resetanetV2_0 - ComDNSFIXO.bat`
2. Selecione **"Executar como administrador"**
3. Aguarde a conclusão de todas as etapas
4. **Reinicie o computador** após a execução (recomendado após reset de Winsock e TCP/IP)

## Avisos

- `netsh advfirewall reset` remove todas as regras personalizadas do firewall, restaurando o padrão de fábrica
- O reset de Winsock e TCP/IP só tem efeito completo após reiniciar o sistema
- O script foi testado em Windows em português; em outros idiomas a detecção do adaptador pode falhar

## Versão

`v2.0` — DNS Fixo (1.1.1.1 / 8.8.8.8)
