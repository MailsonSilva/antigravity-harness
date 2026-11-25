# ==============================================================================
# Antigravity Harness - Verificação Unificada de Qualidade (Windows / Linux / macOS)
# Executa Design System Gate, análise estática e suíte de testes (-j 1)
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
    # 1. Design System Gate (zero cores literais em lib/features/)
    if (-not $SkipLint) {
        $featuresDir = Join-Path "." "lib\features"
        if (Test-Path $featuresDir) {
            Write-Host "`n[1/3] Executando Design System Gate em $targetDir\lib\features..." -ForegroundColor Yellow
            $violations = @()
            Get-ChildItem -Path $featuresDir -Filter "*.dart" -Recurse -File | ForEach-Object {
                $relPath = $_.FullName.Substring((Get-Location).Path.Length + 1) -replace '\\', '/'
                $lineNum = 0
                foreach ($line in [System.IO.File]::ReadAllLines($_.FullName)) {
                    $lineNum++
                    if ($line -match '^\s*//') { continue }
                    if ($line -match 'Color\(0x' -or $line -match '\bColors\.(?!transparent\b)[A-Za-z0-9_]+') {
                        $violations += "${relPath}:${lineNum}: $($line.Trim())"
                    }
                }
            }
            if ($violations.Count -gt 0) {
                Write-Host "❌ Violação de Design System em lib/features/:" -ForegroundColor Red
                $violations | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
                Write-Host "Substitua cores hardcoded (Color(0x...) / Colors.*) pelos tokens semânticos de lib/core/theme/ (_references/brand/DESIGN_SYSTEM.md)." -ForegroundColor Red
                exit 1
            }
            Write-Host "✔ Design System Gate aprovado (zero cores hardcoded em lib/features/)." -ForegroundColor Green
        } else {
            Write-Host "`n[1/3] Diretório 'lib/features/' não encontrado em $targetDir (pulando Design System Gate)." -ForegroundColor Yellow
        }

        # 2. Análise Estática (Dart Analyzer)
        Write-Host "`n[2/3] Executando análise estática em $targetDir (dart analyze)..." -ForegroundColor Yellow
        dart analyze
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Falha na análise estática. Corrija os avisos antes de prosseguir." -ForegroundColor Red
            exit $LASTEXITCODE
        }
        Write-Host "✔ Análise estática limpa sem avisos." -ForegroundColor Green
    } else {
        Write-Host "`n[1/3] Design System Gate ignorado (-SkipLint)." -ForegroundColor DarkGray
        Write-Host "[2/3] Análise estática ignorada (-SkipLint)." -ForegroundColor DarkGray
    }

    # 3. Bateria de Testes com concorrência segura (-j 1 para isolamento SQLite/Windows)
    if (-not $SkipTests) {
        if (Test-Path "test") {
            Write-Host "`n[3/3] Executando suíte de testes em $targetDir (flutter test -j 1)..." -ForegroundColor Yellow
            flutter test -j 1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ Falha nos testes automatizados." -ForegroundColor Red
                exit $LASTEXITCODE
            }
            Write-Host "✔ Todos os testes passaram com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "`n[3/3] Diretório de testes 'test/' não encontrado em $targetDir (pulando testes)." -ForegroundColor Yellow
        }
    } else {
        Write-Host "`n[3/3] Testes ignorados (-SkipTests)." -ForegroundColor DarkGray
    }

    Write-Host "`n=====================================================" -ForegroundColor Green
    Write-Host "  🎉 Gate de Qualidade Aprovado com Sucesso!         " -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Green
}
finally {
    Pop-Location
}
