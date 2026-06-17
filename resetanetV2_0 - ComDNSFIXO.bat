@echo off
setlocal enabledelayedexpansion

:: Auto-elevacao para administrador
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

title Resetanet - Corretor de erros de rede
echo =========================================================
echo            CORRETOR DE ERROS COMUNS DE REDE
echo =========================================================

echo.
echo Detectando adaptador de rede ativo...

set "adapter="
:: Detecta adaptador fisico ativo (espacos duplos evitam match em "Desconectado")
for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr "  Conectado  " ^| findstr /v /i "VMware Loopback vEthernet"') do if "!adapter!"=="" set "adapter=%%a %%b"
if "%adapter%"=="" for /f "tokens=4*" %%a in ('netsh interface show interface ^| findstr "  Connected  " ^| findstr /v /i "VMware Loopback vEthernet"') do if "!adapter!"=="" set "adapter=%%a %%b"
:: Remove espaco final caso %%b seja vazio
if "%adapter:~-1%"==" " set "adapter=%adapter:~0,-1%"

if "%adapter%"=="" (
    echo.
    echo ERRO: Nenhum adaptador de rede ativo encontrado.
    echo Verifique se ha uma conexao de rede ativa e tente novamente.
    pause
    exit /b
)

echo Adaptador ativo: %adapter%
echo.

:: DNS fixo
echo Configurando DNS 1.1.1.1 e 8.8.8.8...
netsh interface ip set dns name="%adapter%" static 1.1.1.1
netsh interface ip add dns name="%adapter%" 8.8.8.8 index=2

echo.
echo Redefinindo configuracoes de rede...
echo.

:: Flush DNS
echo Limpando cache DNS...
ipconfig /flushdns
if %errorlevel% NEQ 0 (
    echo Erro ao limpar cache DNS.
    pause
    exit /b
)

:: Winsock
echo Resetando Winsock...
netsh winsock reset
if %errorlevel% NEQ 0 (
    echo Erro ao resetar Winsock.
    pause
    exit /b
)

:: TCP/IP
echo Resetando TCP/IP...
netsh int ip reset >nul 2>&1
echo Reset TCP/IP concluido.

:: Firewall
echo.
echo AVISO: O proximo passo reseta o Firewall para o padrao de fabrica.
echo Todas as regras personalizadas serao removidas.
echo Pressione qualquer tecla para continuar ou feche a janela para cancelar.
pause
netsh advfirewall reset
if %errorlevel% NEQ 0 (
    echo Erro ao resetar o Firewall.
    pause
    exit /b
)

:: DHCP
echo Reiniciando servico DHCP...
net stop dhcp >nul 2>&1
net start dhcp >nul 2>&1
echo Servico DHCP reiniciado.

:: Register DNS
echo Registrando DNS...
ipconfig /registerdns
if %errorlevel% NEQ 0 (
    echo Erro ao registrar DNS.
    pause
    exit /b
)

:: Reinicia interface e renova IP
echo Reiniciando interface de rede...
netsh interface set interface "%adapter%" disable
timeout /t 3 /nobreak >nul
netsh interface set interface "%adapter%" enable
timeout /t 5 /nobreak >nul
echo Renovando IP...
ipconfig /renew "%adapter%" >nul 2>&1
echo IP renovado.

echo.
echo =========================================================
echo   Correcoes concluidas com sucesso.
echo.
echo   IMPORTANTE: Reinicie o computador para que o reset
echo   do Winsock e TCP/IP tenham efeito completo.
echo =========================================================
echo.
pause
