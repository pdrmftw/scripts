@echo off
echo ============================================
echo        Script de Atualizacao Forcada
echo ============================================

color 1
echo Iniciando processo de atualizacao...
echo ============================================

rem Parte 1: Verificar se o ConstruFarma.UI.WF.exe esta em execucao
echo Verificando se o 'ConstruFarma.UI.WF.exe' esta em execucao...
tasklist /FI "IMAGENAME eq ConstruFarma.UI.WF.exe" 2>NUL | find /I "ConstruFarma.UI.WF.exe" 1>NUL
if not errorlevel 1 (
    color 4
    echo [X] Erro: 'ConstruFarma.UI.WF.exe' esta em execucao.
    exit /B
) else (
    color 1
    echo [V] Sucesso: Nenhum processo 'ConstruFarma.UI.WF.exe' em execucao.
)

echo.

rem Parte 2: Excluir pastas
echo Excluindo pastas...
rmdir /S /Q "Schemas" 1>nul 2>&1
if exist "Schemas" (
    color 4
    echo [X] Falha ao excluir a pasta Schemas.
) else (
    color 1
    echo [V] Sucesso: Pasta Schemas excluida.
)

echo.

rem Parte 3: Excluir arquivos
echo Excluindo arquivos...
setlocal
set "files=ArqTemp ConstruFarma.BLL.dll ConstruFarma.DAL.dll ConstruFarma.UI.WF.exe Versao.json Schemas.zip ArqZipTemp"

for %%F in (%files%) do (
    del /F /Q "%%F" 1>nul 2>&1
    if exist "%%F" (
        color 4
        echo [X] Falha ao excluir %%F.
    ) else (
        color 1
        echo [V] Sucesso: %%F excluido.
    )
)

echo.

rem Parte 4: Excluir ou renomear Log_Erro.txt
set /p resposta="Deseja excluir ou renomear 'Log_Erro.txt' para 'Log_Erro_Data.txt'? (E/R): "
if /I "%resposta%"=="E" (
    del /F /Q "Log_Erro.txt" 1>nul 2>&1
    if exist "Log_Erro.txt" (
        color 4
        echo [X] Falha ao excluir Log_Erro.txt.
    ) else (
        color 1
        echo [V] Sucesso: Log_Erro.txt excluido.
    )
) else (
    for /F "tokens=1-3 delims=/" %%a in ("%date%") do set "data=%%c-%%b-%%a"
    ren "Log_Erro.txt" "Log_Erro_!data:~-8!.txt"
    
    if errorlevel 1 (
        color 4
        echo [X] Falha ao renomear Log_Erro.txt | Erro: %errorlevel%
    ) else (
        color 1
        echo [V] Sucesso: Log_Erro.txt renomeado para Log_Erro_!data:~-8!.txt.
    )
)

echo.

rem Parte 5: Executar Atualizar_Construfarma.exe
set /p resposta="Deseja executar 'Atualizar_Construfarma.exe'? (S/N): "
if /I "%resposta%"=="S" (
    echo [V] Executando 'Atualizar_Construfarma.exe'...
    start /B Atualizar_Construfarma.exe
) else (
    color 6
    echo [X] Atualização não executada.
)

echo ============================================
echo Processo de atualização finalizado.
