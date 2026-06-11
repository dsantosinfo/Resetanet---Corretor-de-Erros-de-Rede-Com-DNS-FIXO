chcp 65001

@echo off
title Resetanet - Corretor de erros de rede
echo =========================================================
echo            CORRETOR DE ERROS COMUNS DE REDE
echo =========================================================
CLS

:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Este script precisa ser executado como administrador.
    echo.
    echo Para continuar, clique com o botão direito no arquivo e selecione "Executar como administrador".
    pause
    exit /b
)

timeout /t 2 /nobreak
echo.
echo Alterando configurações de DNS...
echo.

:: Detecta o nome do adaptador de rede ativo
for /f "tokens=2 delims=:" %%a in ('netsh interface show interface ^| findstr /i "Conectado"') do set "adapter=%%a"
set "adapter=%adapter:~1%"  :: Remove espaços extras

echo Adaptador de rede ativo: %adapter%

:: Altera o DNS para o primário 1.1.1.1 e o secundário 8.8.8.8
echo Configurando DNS primário 1.1.1.1 e DNS secundário 8.8.8.8...
netsh interface ip set dns name="%adapter%" static 1.1.1.1
netsh interface ip add dns name="%adapter%" 8.8.8.8 index=2

echo.
echo Redefinindo configurações de rede e limpando cache DNS...
echo.

:: Reinicia o adaptador de rede
echo Desconectando o adaptador de rede...
ipconfig /release "%adapter%"
if %errorlevel% NEQ 0 (
    echo Erro ao desconectar o adaptador de rede.
    pause
    exit /b
)
echo Aguardando 5 segundos...
timeout /t 5 /nobreak
echo Reconectando o adaptador de rede...
ipconfig /renew "%adapter%"
if %errorlevel% NEQ 0 (
    echo Erro ao reconectar o adaptador de rede.
    pause
    exit /b
)

:: Limpa o cache DNS
echo Limpando cache DNS...
ipconfig /flushdns
if %errorlevel% NEQ 0 (
    echo Erro ao limpar o cache DNS.
    pause
    exit /b
)

:: Reseta o Winsock (reseta a pilha de rede do Windows)
echo Resetando o Winsock...
netsh winsock reset
if %errorlevel% NEQ 0 (
    echo Erro ao resetar o Winsock.
    pause
    exit /b
)

:: Reseta o TCP/IP
echo Resetando o TCP/IP...
netsh int ip reset
if %errorlevel% NEQ 0 (
    echo Erro ao resetar o TCP/IP.
    pause
    exit /b
)

:: Libera portas de firewall (opcional)
echo Liberando as portas do firewall...
netsh advfirewall reset
if %errorlevel% NEQ 0 (
    echo Erro ao liberar as portas do firewall.
    pause
    exit /b
)

:: Reinicia o serviço DHCP
echo Reiniciando o serviço DHCP...
net stop dhcp
net start dhcp
if %errorlevel% NEQ 0 (
    echo Erro ao reiniciar o serviço DHCP.
    pause
    exit /b
)

:: Limpa o cache do cliente DNS (opcional)
echo Limpando o cache do cliente DNS...
ipconfig /registerdns
if %errorlevel% NEQ 0 (
    echo Erro ao limpar o cache do cliente DNS.
    pause
    exit /b
)

:: Reinicia a interface de rede (opcional)
echo Reiniciando a interface de rede...
netsh interface set interface "%adapter%" disable
timeout /t 2 /nobreak
netsh interface set interface "%adapter%" enable
if %errorlevel% NEQ 0 (
    echo Erro ao reiniciar a interface de rede.
    pause
    exit /b
)

echo.
echo Correções de rede concluídas com sucesso.
pause
