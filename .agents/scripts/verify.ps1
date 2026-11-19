# ==============================================================================
# Antigravity Harness - Verificação Unificada de Qualidade (Windows / Linux / macOS)
# Executa análise estática e suíte de testes com isolamento de locks (-j 1)
# ==============================================================================

param(
    [switch]$SkipTests = $false,
    [switch]$SkipLint = $false,
    [string]$AppPath = "."
)

$ErrorActionPreference = "Stop"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  🔍 Verificação de Qualidade do Antigravity Harness " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

$targetDir = $AppPath
if (-not (Test-Path (Join-Path $targetDir "pubspec.yaml")) -and (Test-Path "apps\mobile\pubspec.yaml")) {
    $targetDir = "apps\mobile"
}

Push-Location $targetDir

try {
    # 1. Análise Estática (Dart Analyzer)
    if (-not $SkipLint) {
        Write-Host "`n[1/2] Executando análise estática em $targetDir (dart analyze)..." -ForegroundColor Yellow
        dart analyze
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Falha na análise estática. Corrija os avisos antes de prosseguir." -ForegroundColor Red
            exit $LASTEXITCODE
        }
        Write-Host "✔ Análise estática limpa sem avisos." -ForegroundColor Green
    } else {
        Write-Host "`n[1/2] Análise estática ignorada (--SkipLint)." -ForegroundColor DarkGray
    }

    # 2. Bateria de Testes com concorrência segura (-j 1 para isolamento SQLite/Windows)
    if (-not $SkipTests) {
        if (Test-Path "test") {
            Write-Host "`n[2/2] Executando suíte de testes em $targetDir (flutter test -j 1)..." -ForegroundColor Yellow
            flutter test -j 1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ Falha nos testes automatizados." -ForegroundColor Red
                exit $LASTEXITCODE
            }
            Write-Host "✔ Todos os testes passaram com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "`n[2/2] Diretório de testes 'test/' não encontrado em $targetDir (pulando testes)." -ForegroundColor Yellow
        }
    } else {
        Write-Host "`n[2/2] Testes ignorados (--SkipTests)." -ForegroundColor DarkGray
    }

    Write-Host "`n=====================================================" -ForegroundColor Green
    Write-Host "  🎉 Gate de Qualidade Aprovado com Sucesso!         " -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Green
}
finally {
    Pop-Location
}
