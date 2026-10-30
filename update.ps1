# ==============================================================================
# Antigravity Harness - Script de Atualização Universal (PowerShell)
# Preserva 100% de PROJECT_BRAIN.md e skills existentes
# ==============================================================================

param(
    [string]$TargetDir = "."
)

$ErrorActionPreference = "Stop"
Write-Host "`n🔄 [Harness Update] Iniciando sincronização segura..." -ForegroundColor Cyan

Set-Location $TargetDir

# Garante a existência das pastas canônicas
$essentialDirs = @(
    ".agents\rules",
    ".agents\workflows",
    ".agents\memory",
    ".agents\skills\harness-evolver",
    "_specs\features",
    "_specs\tasks",
    "_references\screens",
    "_references\brand"
)

foreach ($d in $essentialDirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# Garante tracking das pastas de referência
if (-not (Test-Path "_references\screens\.gitkeep")) { Set-Content -Path "_references\screens\.gitkeep" -Value "" }
if (-not (Test-Path "_references\brand\.gitkeep")) { Set-Content -Path "_references\brand\.gitkeep" -Value "" }

Write-Host "✅ Estrutura de diretórios sincronizada com sucesso!" -ForegroundColor Green
Write-Host "ℹ️ Memória do projeto e skills customizadas preservadas sem alteração.`n" -ForegroundColor Cyan
