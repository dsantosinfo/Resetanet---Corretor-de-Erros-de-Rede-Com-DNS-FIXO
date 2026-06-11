@echo off
chcp 65001 >nul
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

timeout /t 2 /nobreak >nul
echo.
echo Alterando configurações de DNS...
echo.

:: Detecta o nome do adaptador de rede ativo (suporte a PT e EN)
for /f "tokens=2 delims=:" %%a in ('netsh interface show interface ^| findstr /i "Conectado Connected"') do set "adapter=%%a"
:: Remove espaço inicial do nome do adaptador
set "adapter=%adapter:~1%"

if "%adapter%"=="" (
    echo Nenhum adaptador de rede ativo encontrado.
    pause
    exit /b
)

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
timeout /t 5 /nobreak >nul
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

:: Reseta o Winsock
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

:: Reseta o Firewall para o padrão — remove TODAS as regras personalizadas
echo.
echo AVISO: O próximo passo vai resetar o Firewall do Windows para o padrão de fábrica.
echo Todas as regras personalizadas serão removidas.
echo Pressione qualquer tecla para continuar ou feche a janela para cancelar.
pause
netsh advfirewall reset
if %errorlevel% NEQ 0 (
    echo Erro ao resetar o Firewall.
    pause
    exit /b
)

:: Reinicia o serviço DHCP (ignora erro se já estiver parado)
echo Reiniciando o serviço DHCP...
net stop dhcp >nul 2>&1
net start dhcp
if %errorlevel% NEQ 0 (
    echo Erro ao iniciar o serviço DHCP.
    pause
    exit /b
)

:: Registra o DNS
echo Registrando DNS...
ipconfig /registerdns
if %errorlevel% NEQ 0 (
    echo Erro ao registrar o DNS.
    pause
    exit /b
)

:: Reinicia a interface de rede
echo Reiniciando a interface de rede...
netsh interface set interface "%adapter%" disable
timeout /t 2 /nobreak >nul
netsh interface set interface "%adapter%" enable
if %errorlevel% NEQ 0 (
    echo Erro ao reiniciar a interface de rede.
    pause
    exit /b
)

echo.
echo =========================================================
echo   Correções de rede concluídas com sucesso.
echo.
echo   IMPORTANTE: Reinicie o computador para que o reset
echo   do Winsock e TCP/IP tenham efeito completo.
echo =========================================================
echo.
pause
