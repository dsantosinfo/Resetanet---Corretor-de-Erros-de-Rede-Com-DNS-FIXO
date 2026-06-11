*Passo a Passo para Usar o Script "Resetanet - Corretor de Erros de Rede"*

1. **Baixar o Script**
   - Clique com o botão direito do mouse no arquivo do script que você recebeu e selecione a opção "Salvar como..." para salvar o arquivo em seu computador.

2. **Abrir o Script**
   - Localize o arquivo salvo em seu computador (geralmente com a extensão `.bat`) e clique duas vezes sobre ele para abrir. 
   - **Importante**: Você precisa de privilégios de administrador para executar o script corretamente.

3. **Executar como Administrador**
   - Caso o script não abra automaticamente com privilégios de administrador, siga os passos abaixo:
     - Clique com o botão direito do mouse sobre o arquivo.
     - Selecione a opção "Executar como administrador".
     - Se solicitado, confirme a execução com a opção "Sim".

4. **O Script irá Rodar Automaticamente**
   - Após abrir, o script irá executar automaticamente várias etapas para corrigir erros de rede, incluindo:
     - Alteração dos servidores DNS para **1.1.1.1** (primário) e **8.8.8.8** (secundário).
     - Desconexão e reconexão do adaptador de rede.
     - Limpeza de cache DNS.
     - Reset de configurações de rede (Winsock e TCP/IP).
     - Reinício do serviço DHCP e outras operações.

5. **Aguardar a Execução Completa**
   - O script irá executar as ações automaticamente e exibir mensagens na tela indicando o progresso. Isso pode levar alguns minutos.
   - Caso algum erro ocorra, o script irá avisá-lo e solicitará que você o execute novamente com privilégios de administrador.

6. **Concluir**
   - Quando o script terminar, você verá a mensagem **"Correções de rede concluídas com sucesso."**.
   - Você pode então fechar o prompt de comando ou pressionar qualquer tecla para finalizar.
