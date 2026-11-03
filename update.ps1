# ==============================================================================
# Antigravity Harness - Atualizador Universal (Windows PowerShell 5.1+)
# Sincroniza o harness com o repositorio upstream preservando dados locais.
#
# Uso:  .\update.ps1 [-TargetDir .] [-Repo MailsonSilva/antigravity-harness] [-Branch main]
#
# PRESERVADO (nunca sobrescrito):
#   .agents/PROJECT_BRAIN.md     .agents/skills/** (skills existentes)
#   .agents/memory/**            apps/  _references/
#   _specs/prd.md  _specs/features/  _specs/tasks/T*.md  README.md  .git/
#
# ATUALIZADO (backup previo em %TEMP%\harness-backup-<data>):
#   .agents/harness.yaml  .agents/mcp.json  .agents/rules/**  .agents/workflows/**
#   harness-studio.html  _specs/prd-template.md  _specs/tasks/_template.md
#   install.ps1  install.sh  update.ps1  update.sh
#
# CRIADO SOMENTE SE AUSENTE:
#   .agents/PROJECT_BRAIN.md  _specs/task-board.md
# ==============================================================================

param(
    [string]$TargetDir = ".",
    [string]$Repo = "MailsonSilva/antigravity-harness",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host $msg -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host $msg -ForegroundColor Green }
function Write-Warn($msg) { Write-Host $msg -ForegroundColor DarkYellow }

if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    throw "git nao encontrado no PATH. Instale o Git para sincronizar o harness."
}

Set-Location $TargetDir

if (-not (Test-Path ".agents\harness.yaml")) {
    throw "Harness nao encontrado em $(Get-Location). Rode o install.ps1 primeiro."
}

# Aceita "owner/repo", URL completa ou caminho local (util para testes).
$repoUrl = $Repo
if ($Repo -notmatch '^(https?://|git@|file://|[A-Za-z]:[\\/]|\.{1,2}[\\/]|/)') {
    $repoUrl = "https://github.com/$Repo.git"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$work = Join-Path ([IO.Path]::GetTempPath()) "harness-update-$stamp"
$backup = Join-Path ([IO.Path]::GetTempPath()) "harness-backup-$stamp"

New-Item -ItemType Directory -Path $work -Force | Out-Null

try {
    Write-Step "Sincronizando de $repoUrl (branch $Branch)..."

    # Git pode emitir warnings em stderr (ex.: clone local ignora --depth).
    # Com ErrorActionPreference=Stop isso viraria excecao; por isso isolamos
    # o clone e validamos apenas o codigo de saida real.
    $previousEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $cloneOutput = & git clone --quiet --depth 1 --branch $Branch $repoUrl $work 2>&1
    $cloneExit = $LASTEXITCODE
    $ErrorActionPreference = $previousEap
    if ($cloneExit -ne 0) {
        throw "git clone falhou para $repoUrl (codigo $cloneExit): $($cloneOutput -join ' ')"
    }
    $src = $work

    # Backup dos arquivos gerenciados antes de sobrescrever.
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    foreach ($p in @(".agents\harness.yaml", ".agents\mcp.json", ".agents\rules", ".agents\workflows", "harness-studio.html")) {
        if (Test-Path $p) {
            $dest = Join-Path $backup $p
            New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
            Copy-Item -Recurse -Force $p $dest
        }
    }

    # 1. Estrutura canonica.
    $dirs = @(
        ".agents\rules",
        ".agents\workflows",
        ".agents\memory",
        ".agents\skills",
        "_specs\features",
        "_specs\tasks",
        "_references\screens",
        "_references\brand"
    )
    foreach ($d in $dirs) {
        if (-not (Test-Path $d)) {
            New-Item -ItemType Directory -Path $d -Force | Out-Null
        }
    }

    # 2. Arquivos gerenciados (sobrescritos pelo upstream).
    $managed = @(
        ".agents\harness.yaml",
        ".agents\mcp.json",
        "_specs\prd-template.md",
        "_specs\tasks\_template.md",
        "harness-studio.html",
        "install.ps1",
        "install.sh",
        "update.ps1",
        "update.sh"
    )
    foreach ($f in $managed) {
        $from = Join-Path $src ($f -replace '\\', '/')
        if (Test-Path $from) {
            $parent = Split-Path -Parent $f
            if ($parent -and -not (Test-Path $parent)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }
            Copy-Item -Force $from $f
        }
    }

    # 3. Regras e workflows.
    foreach ($d in @(".agents\rules", ".agents\workflows")) {
        $from = Join-Path $src ($d -replace '\\', '/')
        if (Test-Path $from) {
            if (-not (Test-Path $d)) {
                New-Item -ItemType Directory -Path $d -Force | Out-Null
            }
            Copy-Item -Path (Join-Path $from "*") -Destination $d -Recurse -Force
        }
    }

    # 4. Skills: preserva as existentes e adiciona apenas as novas.
    $srcSkills = Join-Path $src ".agents/skills"
    if (Test-Path $srcSkills) {
        if (-not (Test-Path ".agents\skills")) {
            New-Item -ItemType Directory -Path ".agents\skills" -Force | Out-Null
        }
        Get-ChildItem -Path $srcSkills -Directory | ForEach-Object {
            $dest = Join-Path ".agents\skills" $_.Name
            if (-not (Test-Path $dest)) {
                Copy-Item -Recurse -Force $_.FullName $dest
                Write-Step "  + skill nova: $($_.Name)"
            }
        }
    }

    # 5. PROJECT_BRAIN: cria somente se ainda nao existir.
    $brainSrc = Join-Path $src ".agents/PROJECT_BRAIN.md"
    if ((Test-Path $brainSrc) -and (-not (Test-Path ".agents\PROJECT_BRAIN.md"))) {
        Copy-Item -Force $brainSrc ".agents\PROJECT_BRAIN.md"
    }

    # 5.1 Task board: cria somente se ainda nao existir (preserva o Kanban local).
    $boardSrc = Join-Path $src "_specs/task-board.md"
    if ((Test-Path $boardSrc) -and (-not (Test-Path "_specs\task-board.md"))) {
        if (-not (Test-Path "_specs")) {
            New-Item -ItemType Directory -Path "_specs" -Force | Out-Null
        }
        Copy-Item -Force $boardSrc "_specs\task-board.md"
    }

    # 6. Marcadores de versionamento das pastas vazias.
    if (-not (Test-Path "_references\screens\.gitkeep")) { Set-Content -Path "_references\screens\.gitkeep" -Value "" }
    if (-not (Test-Path "_references\brand\.gitkeep")) { Set-Content -Path "_references\brand\.gitkeep" -Value "" }
    if (-not (Test-Path ".agents\memory\.gitkeep")) { Set-Content -Path ".agents\memory\.gitkeep" -Value "" }

    Write-Ok "Harness v2.1 sincronizado com $repoUrl@$Branch."
    Write-Ok "Preservados: PROJECT_BRAIN.md, .agents/skills/, .agents/memory/ e _specs/task-board.md."
    Write-Ok "Sincronizado quando presente: harness-studio.html, harness.yaml, mcp.json (Dart MCP) e regras."
    Write-Warn "Backup dos arquivos gerenciados: $backup"
}
finally {
    if (Test-Path $work) {
        Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
    }
}
