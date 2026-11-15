# ==============================================================================
# Antigravity Harness Setup (Windows / PowerShell)
# Configura o ambiente Antigravity copiando core + perfil selecionado para o projeto.
# Uso:
#   .\setup.ps1 -Profile flutter [-TargetDir <caminho>]
#   .\setup.ps1 -Profile web     [-TargetDir <caminho>]
# ==============================================================================

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("flutter", "mobile", "web", "web-sites")]
    [string]$Profile,

    [Parameter(Mandatory = $false)]
    [string]$TargetDir = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$HarnessRoot = $PSScriptRoot
if (-not (Test-Path (Join-Path $HarnessRoot "core"))) {
    # Fallback se executado via web/pipeline
    $HarnessRoot = (Get-Location).Path
}

# Normalização de perfil
$ProfileFolder = "flutter"
$ProfileMd = "GEMINI.flutter.md"
if ($Profile -in @("web", "web-sites")) {
    $ProfileFolder = "web-sites"
    $ProfileMd = "GEMINI.web.md"
}

Write-Host "`n🚀 Configurando Antigravity Harness ($ProfileFolder)..." -ForegroundColor Cyan
Write-Host "📁 Destino: $TargetDir" -ForegroundColor DarkGray

$CoreDir = Join-Path $HarnessRoot "core"
$SelectedProfileDir = Join-Path $HarnessRoot "profiles\$ProfileFolder"

if (-not (Test-Path $CoreDir) -or -not (Test-Path $SelectedProfileDir)) {
    Write-Error "Diretórios de origem não encontrados em $HarnessRoot. Certifique-se de executar o script a partir do repositório antigravity-harness."
    exit 1
}

# 1. Preparar pastas de destino
$AgentsDir = Join-Path $TargetDir ".agents"
$WorkflowsDir = Join-Path $AgentsDir "workflows"
$SkillsDir = Join-Path $AgentsDir "skills"
$SpecsDir = Join-Path $TargetDir "_specs"

New-Item -ItemType Directory -Path $AgentsDir -Force | Out-Null
New-Item -ItemType Directory -Path $WorkflowsDir -Force | Out-Null
New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
New-Item -ItemType Directory -Path $SpecsDir -Force | Out-Null

# 2. Copiar Workflows Core
Write-Host "📦 Copiando workflows (plan.md e orchestrate.md)..." -ForegroundColor Green
Copy-Item -Path (Join-Path $CoreDir "workflows\*") -Destination $WorkflowsDir -Recurse -Force

# 3. Copiar Skills do Perfil
Write-Host "🧠 Instalando skills do perfil $ProfileFolder..." -ForegroundColor Green
$ProfileSkillsDir = Join-Path $SelectedProfileDir "skills"
if (Test-Path $ProfileSkillsDir) {
    Get-ChildItem -Path $ProfileSkillsDir -Directory | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination (Join-Path $SkillsDir $_.Name) -Recurse -Force
    }
}

# 4. Gerar GEMINI.md Unificado
Write-Host "📝 Gerando GEMINI.md consolidado na raiz do projeto..." -ForegroundColor Green
$BaseMdContent = Get-Content -Path (Join-Path $CoreDir "GEMINI.base.md") -Raw
$ProfileMdContent = Get-Content -Path (Join-Path $SelectedProfileDir $ProfileMd) -Raw

$UnifiedGeminiMd = @"
$BaseMdContent

---

$ProfileMdContent
"@

$TargetGeminiFile = Join-Path $TargetDir "GEMINI.md"
Set-Content -Path $TargetGeminiFile -Value $UnifiedGeminiMd -Encoding UTF8
Set-Content -Path (Join-Path $AgentsDir "GEMINI.md") -Value $UnifiedGeminiMd -Encoding UTF8

Write-Host "`n✅ Antigravity Harness configurado com sucesso!" -ForegroundColor Cyan
Write-Host "   - Perfil ativo: $ProfileFolder" -ForegroundColor White
Write-Host "   - Diretrizes:   $TargetGeminiFile" -ForegroundColor White
Write-Host "   - Workflows:    $WorkflowsDir" -ForegroundColor White
Write-Host "   - Skills:       $SkillsDir`n" -ForegroundColor White
