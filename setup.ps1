# ==============================================================================
# Antigravity Harness Setup & Update (Windows / PowerShell 5.1+)
# Configura ou atualiza o ambiente Antigravity (v4 Modular) no projeto-alvo.
# Uso:
#   .\setup.ps1 -Profile flutter [-TargetDir <caminho>] [-WithOptionalMcps] [-InitApp]
#   .\setup.ps1 -Profile web     [-TargetDir <caminho>] [-Repo <owner/repo>] [-Branch main]
# ==============================================================================

param(
    [Parameter(Mandatory = $true)]
    [string]$Profile,

    [Parameter(Mandatory = $false)]
    [string]$TargetDir = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string]$Repo = "MailsonSilva/antigravity-harness",

    [Parameter(Mandatory = $false)]
    [string]$Branch = "main",

    [Parameter(Mandatory = $false)]
    [string]$AppDir = "",

    [Parameter(Mandatory = $false)]
    [string]$Org = "com.example",

    [Parameter(Mandatory = $false)]
    [string]$ProjectName = "",

    [switch]$InitApp,

    [switch]$WithOptionalMcps
)

$ErrorActionPreference = "Stop"
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-Utf8NoBom {
    param([string]$Path, [string]$Content)
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Get-FileSha256 {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return "" }
    return (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Parse-ProfileYaml {
    param([string]$YamlPath)
    $result = @{
        name         = ""
        aliases      = @()
        display_name = ""
        gemini_file  = ""
        mcps_default = @()
        mcps_optional = @()
        dir          = Split-Path -Parent $YamlPath
    }
    $section = ""
    $subSection = ""
    foreach ($rawLine in (Get-Content -Path $YamlPath -Encoding UTF8)) {
        $line = $rawLine -replace '\s+#.*$', ''
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        if ($line -match '^([a-zA-Z0-9_]+):\s*(.*)$') {
            $key = $Matches[1]
            $val = $Matches[2].Trim().Trim('"').Trim("'")
            $section = $key
            $subSection = ""
            if ($key -in @("name", "display_name", "gemini_file") -and $val -ne "") {
                $result[$key] = $val
            }
        }
        elseif ($line -match '^\s{2}([a-zA-Z0-9_]+):\s*(.*)$') {
            $subKey = $Matches[1]
            $subVal = $Matches[2].Trim()
            $subSection = $subKey
            # Suporta lista vazia inline []
            if ($subVal -eq "[]") { continue }
        }
        elseif ($line -match '^\s+-\s+(.+)$') {
            $item = $Matches[1].Trim().Trim('"').Trim("'")
            if ($section -eq "aliases") {
                $result.aliases += $item
            }
            elseif ($section -eq "mcps" -and $subSection -eq "default") {
                $result.mcps_default += $item
            }
            elseif ($section -eq "mcps" -and $subSection -eq "optional") {
                $result.mcps_optional += $item
            }
        }
    }
    return $result
}

function Get-McpCatalog {
    return @{
        dart_mcp = @{
            command     = "dart"
            args        = @("mcp-server")
            description = "Inspeção da árvore de widgets em runtime, resolução de símbolos, pubspec e execução assistida de testes Flutter."
        }
        supabase_mcp = @{
            command     = "npx"
            args        = @("-y", "@supabase/mcp-server-supabase@latest")
            description = "Inspeção de schema Postgres, criação de migrations, políticas RLS, Edge Functions e geração de tipos."
        }
        google_stitch = @{
            command     = "npx"
            args        = @("-y", "@google/stitch-mcp-server")
            env         = @{
                STITCH_REFERENCES_DIR = "./_references/screens"
                STITCH_OUTPUT_DIR     = "./_specs"
            }
            description = "Extração de Design Tokens e fidelidade visual a partir de telas em _references/screens/."
        }
        patrol_mcp = @{
            command     = "dart"
            args        = @("run", "patrol_mcp")
            description = "Testes E2E em dispositivos/emuladores com interação nativa via Patrol MCP."
        }
        graft_ast = @{
            command     = "graft"
            args        = @("mcp", "--watch")
            description = "Navegação em árvore sintática (AST) para localizar chamadas e impactos."
        }
        ai_memory = @{
            command     = "ai-memory"
            args        = @("mcp")
            env         = @{
                AI_MEMORY_DB_PATH = "./.agents/memory/context.db"
            }
            description = "Memória episódica de decisões arquiteturais entre subagentes."
        }
    }
}

$TempCloneDir = $null
try {
    # 1. Resolver fonte (local vs remota)
    $SourceType = "local"
    $HarnessRoot = $PSScriptRoot
    if (-not $HarnessRoot -or -not (Test-Path (Join-Path $HarnessRoot "core"))) {
        $SourceType = "remote"
        $TempCloneDir = Join-Path $env:TEMP ("antigravity-harness-" + [Guid]::NewGuid().ToString("N"))
        $RepoUrl = "https://github.com/$Repo.git"
        Write-Host "`n🌐 Baixando Antigravity Harness ($Repo@$Branch)..." -ForegroundColor Cyan
        git clone --quiet --depth 1 --branch $Branch $RepoUrl $TempCloneDir
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao clonar $RepoUrl (branch $Branch)."
        }
        $HarnessRoot = $TempCloneDir
    }

    $CoreDir = Join-Path $HarnessRoot "core"
    $ProfilesRoot = Join-Path $HarnessRoot "profiles"
    if (-not (Test-Path $CoreDir) -or -not (Test-Path $ProfilesRoot)) {
        throw "Estrutura inválida em $HarnessRoot (core/ ou profiles/ ausentes)."
    }

    # 2. Descobrir e resolver perfil dinamicamente via profile.yaml
    $SelectedProfile = $null
    $ProfileYamls = Get-ChildItem -Path $ProfilesRoot -Filter "profile.yaml" -Recurse
    foreach ($yamlFile in $ProfileYamls) {
        $parsed = Parse-ProfileYaml -YamlPath $yamlFile.FullName
        if ($parsed.name -eq $Profile -or ($parsed.aliases -contains $Profile)) {
            $SelectedProfile = $parsed
            break
        }
    }
    if (-not $SelectedProfile) {
        $available = ($ProfileYamls | ForEach-Object { (Parse-ProfileYaml -YamlPath $_.FullName).name }) -join ", "
        throw "Perfil '$Profile' não encontrado. Perfis disponíveis: $available"
    }

    $ProfileName = $SelectedProfile.name
    $SelectedProfileDir = $SelectedProfile.dir
    $ProfileMd = $SelectedProfile.gemini_file

    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    $TargetDir = (Resolve-Path $TargetDir).Path

    Write-Host "`n🚀 Configurando Antigravity Harness ($ProfileName)..." -ForegroundColor Cyan
    Write-Host "📁 Destino: $TargetDir" -ForegroundColor DarkGray

    $AgentsDir = Join-Path $TargetDir ".agents"
    $WorkflowsDir = Join-Path $AgentsDir "workflows"
    $SkillsDir = Join-Path $AgentsDir "skills"
    $SpecsDir = Join-Path $TargetDir "_specs"
    $ManifestPath = Join-Path $AgentsDir ".harness-manifest.json"

    # 3. Carregar manifesto anterior (se existir) e criar backup de arquivos gerenciados
    $PreviousManifest = $null
    $InstalledAt = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    if (Test-Path $ManifestPath) {
        try {
            $PreviousManifest = Get-Content -Path $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($PreviousManifest.installedAt) {
                $InstalledAt = $PreviousManifest.installedAt
            }
        } catch {
            Write-Warning "Manifesto anterior inválido; será recriado."
        }
    }

    $BackupCandidates = @("GEMINI.md", ".agents\workflows", ".agents\mcp.json", "harness-studio.html")
    $HasExisting = $false
    foreach ($c in $BackupCandidates) {
        if (Test-Path (Join-Path $TargetDir $c)) { $HasExisting = $true; break }
    }
    if ($HasExisting) {
        $BackupDir = Join-Path $env:TEMP ("harness-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        foreach ($c in $BackupCandidates) {
            $src = Join-Path $TargetDir $c
            if (Test-Path $src) {
                $dst = Join-Path $BackupDir $c
                $dstParent = Split-Path -Parent $dst
                if (-not (Test-Path $dstParent)) { New-Item -ItemType Directory -Path $dstParent -Force | Out-Null }
                Copy-Item -Path $src -Destination $dst -Recurse -Force
            }
        }
        Write-Host "🛟 Backup criado em: $BackupDir" -ForegroundColor DarkGray
    }

    New-Item -ItemType Directory -Path $AgentsDir, $WorkflowsDir, $SkillsDir, $SpecsDir -Force | Out-Null

    $ManagedFiles = @()
    $ManagedSkills = @()

    # 4. Copiar Workflows Core
    Write-Host "📦 Atualizando workflows (plan.md e orchestrate.md)..." -ForegroundColor Green
    Get-ChildItem -Path (Join-Path $CoreDir "workflows") -File | ForEach-Object {
        $destFile = Join-Path $WorkflowsDir $_.Name
        Copy-Item -Path $_.FullName -Destination $destFile -Force
        $ManagedFiles += @{ path = ".agents/workflows/$($_.Name)"; sha256 = (Get-FileSha256 $destFile) }
    }

    # 5. Copiar Skills (core/skills + profiles/<perfil>/skills) preservando skills customizadas do usuário
    Write-Host "🧠 Instalando skills ($ProfileName)..." -ForegroundColor Green
    $SkillSources = @()
    $CoreSkillsDir = Join-Path $CoreDir "skills"
    if (Test-Path $CoreSkillsDir) {
        $SkillSources += Get-ChildItem -Path $CoreSkillsDir -Directory
    }
    $ProfileSkillsDir = Join-Path $SelectedProfileDir "skills"
    if (Test-Path $ProfileSkillsDir) {
        $SkillSources += Get-ChildItem -Path $ProfileSkillsDir -Directory
    }

    foreach ($skillFolder in $SkillSources) {
        $destSkill = Join-Path $SkillsDir $skillFolder.Name
        if (Test-Path $destSkill) { Remove-Item -Path $destSkill -Recurse -Force }
        Copy-Item -Path $skillFolder.FullName -Destination $destSkill -Recurse -Force
        if ($ManagedSkills -notcontains $skillFolder.Name) {
            $ManagedSkills += $skillFolder.Name
        }
    }

    # Remover apenas skills antigas que pertenciam ao manifesto anterior e saíram do perfil
    if ($PreviousManifest -and $PreviousManifest.managedSkills) {
        foreach ($oldSkill in $PreviousManifest.managedSkills) {
            if ($ManagedSkills -notcontains $oldSkill) {
                $oldPath = Join-Path $SkillsDir $oldSkill
                if (Test-Path $oldPath) {
                    Remove-Item -Path $oldPath -Recurse -Force
                }
            }
        }
    }

    # 6. Gerar GEMINI.md Unificado apenas na raiz
    Write-Host "📝 Gerando GEMINI.md na raiz do projeto..." -ForegroundColor Green
    $BaseMdContent = (Get-Content -Path (Join-Path $CoreDir "GEMINI.base.md") -Raw -Encoding UTF8).TrimEnd()
    $ProfileMdContent = (Get-Content -Path (Join-Path $SelectedProfileDir $ProfileMd) -Raw -Encoding UTF8).TrimEnd()
    $UnifiedGeminiMd = "$BaseMdContent`n`n---`n`n$ProfileMdContent`n"

    if ($ProfileName -eq "flutter") {
        $ResolvedAppDir = $AppDir
        if ([string]::IsNullOrWhiteSpace($ResolvedAppDir)) {
            if (Test-Path (Join-Path $TargetDir "apps\mobile\pubspec.yaml")) {
                $ResolvedAppDir = "apps/mobile"
            } else {
                $ResolvedAppDir = "."
            }
        }
        $bt = [char]96
        $UnifiedGeminiMd += "`n---`n`n## Workspace Flutter Detectado`n- Diretório do pacote Dart/Flutter: " + $bt + $ResolvedAppDir + $bt + " (execute " + $bt + "flutter test" + $bt + " e " + $bt + "dart analyze" + $bt + " a partir deste caminho).`n"
    }

    $TargetGeminiFile = Join-Path $TargetDir "GEMINI.md"
    Write-Utf8NoBom -Path $TargetGeminiFile -Content $UnifiedGeminiMd
    $ManagedFiles += @{ path = "GEMINI.md"; sha256 = (Get-FileSha256 $TargetGeminiFile) }

    # 7. Gerar .agents/mcp.json (MCPs pesados estritamente opt-in)
    $McpCatalog = Get-McpCatalog
    $SelectedMcps = @{}
    foreach ($m in $SelectedProfile.mcps_default) {
        if ($McpCatalog.ContainsKey($m)) { $SelectedMcps[$m] = $McpCatalog[$m] }
    }
    if ($WithOptionalMcps) {
        foreach ($m in $SelectedProfile.mcps_optional) {
            if ($McpCatalog.ContainsKey($m)) { $SelectedMcps[$m] = $McpCatalog[$m] }
        }
    }
    $McpJsonObj = @{ mcpServers = $SelectedMcps }
    $McpJsonPath = Join-Path $AgentsDir "mcp.json"
    Write-Utf8NoBom -Path $McpJsonPath -Content ($McpJsonObj | ConvertTo-Json -Depth 6)
    $ManagedFiles += @{ path = ".agents/mcp.json"; sha256 = (Get-FileSha256 $McpJsonPath) }

    # 8. Copiar harness-studio.html, COMANDOS.md e inicializar templates somente se não existirem
    $StudioSource = Join-Path $HarnessRoot "harness-studio.html"
    if (Test-Path $StudioSource) {
        $StudioDest = Join-Path $TargetDir "harness-studio.html"
        Copy-Item -Path $StudioSource -Destination $StudioDest -Force
        $ManagedFiles += @{ path = "harness-studio.html"; sha256 = (Get-FileSha256 $StudioDest) }
    }

    $ComandosSource = Join-Path $HarnessRoot "COMANDOS.md"
    if (Test-Path $ComandosSource) {
        $ComandosDest = Join-Path $AgentsDir "COMANDOS.md"
        Copy-Item -Path $ComandosSource -Destination $ComandosDest -Force
        $ManagedFiles += @{ path = ".agents/COMANDOS.md"; sha256 = (Get-FileSha256 $ComandosDest) }
    }

    $BoardTemplate = Join-Path $CoreDir "templates\board.json"
    $TargetBoard = Join-Path $SpecsDir "board.json"
    if ((Test-Path $BoardTemplate) -and -not (Test-Path $TargetBoard)) {
        Copy-Item -Path $BoardTemplate -Destination $TargetBoard -Force
    }

    $BrainTemplate = Join-Path $CoreDir "templates\PROJECT_BRAIN.md"
    $TargetBrain = Join-Path $AgentsDir "PROJECT_BRAIN.md"
    if ((Test-Path $BrainTemplate) -and -not (Test-Path $TargetBrain)) {
        Copy-Item -Path $BrainTemplate -Destination $TargetBrain -Force
    }

    $FeedbackTemplate = Join-Path $CoreDir "templates\HARNESS_FEEDBACK.md"
    $TargetFeedback = Join-Path $AgentsDir "HARNESS_FEEDBACK.md"
    if ((Test-Path $FeedbackTemplate) -and -not (Test-Path $TargetFeedback)) {
        Copy-Item -Path $FeedbackTemplate -Destination $TargetFeedback -Force
    }

    # 8.1 Scaffolding inicial do app Flutter (-InitApp)
    if ($InitApp -and $ProfileName -eq "flutter") {
        $TargetAppPath = if ([string]::IsNullOrWhiteSpace($AppDir)) { $TargetDir } else { Join-Path $TargetDir $AppDir }
        if (-not (Test-Path $TargetAppPath)) {
            New-Item -ItemType Directory -Path $TargetAppPath -Force | Out-Null
        }

        if (-not (Test-Path (Join-Path $TargetAppPath "pubspec.yaml"))) {
            $RawName = if ([string]::IsNullOrWhiteSpace($ProjectName)) { Split-Path -Leaf $TargetAppPath } else { $ProjectName }
            $ResolvedProjectName = (($RawName.ToLowerInvariant() -replace '[^a-z0-9]+', '_') -replace '^_+|_+$', '')
            if ([string]::IsNullOrWhiteSpace($ResolvedProjectName) -or ($ResolvedProjectName -match '^[0-9]')) {
                $ResolvedProjectName = "flutter_app"
            }

            if (Get-Command flutter -ErrorAction SilentlyContinue) {
                Write-Host "📱 Executando flutter create ($ResolvedProjectName)..." -ForegroundColor Green
                flutter create --org $Org --project-name $ResolvedProjectName $TargetAppPath
                if ($LASTEXITCODE -ne 0) {
                    Write-Warning "flutter create retornou código $LASTEXITCODE; prosseguindo com criação das pastas."
                }
            } else {
                Write-Warning "Comando 'flutter' não encontrado no PATH; criando apenas estrutura de pastas."
            }
        }

        $FlutterFolders = @(
            "lib\core\database", "lib\core\errors", "lib\core\network", "lib\core\theme",
            "lib\features", "test\core", "test\features", "integration_test"
        )
        foreach ($folder in $FlutterFolders) {
            New-Item -ItemType Directory -Path (Join-Path $TargetAppPath $folder) -Force | Out-Null
        }
        New-Item -ItemType Directory -Path (Join-Path $TargetDir "_references\brand"), (Join-Path $TargetDir "_references\screens") -Force | Out-Null
    }

    # 9. Gravar manifesto .agents/.harness-manifest.json
    $ManifestObj = [ordered]@{
        schemaVersion       = 1
        harnessVersion      = "4.0.0"
        profile             = $ProfileName
        source              = [ordered]@{
            type   = $SourceType
            repo   = $Repo
            branch = $Branch
        }
        installedAt         = $InstalledAt
        updatedAt           = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        optionalMcpsEnabled = [bool]$WithOptionalMcps
        managedFiles        = $ManagedFiles
        managedSkills       = $ManagedSkills
    }
    Write-Utf8NoBom -Path $ManifestPath -Content ($ManifestObj | ConvertTo-Json -Depth 6)

    Write-Host "`n✅ Antigravity Harness v4 configurado com sucesso!" -ForegroundColor Cyan
    Write-Host "   - Perfil ativo: $ProfileName" -ForegroundColor White
    Write-Host "   - Diretrizes:   $TargetGeminiFile" -ForegroundColor White
    Write-Host "   - Manifesto:    $ManifestPath" -ForegroundColor White
    Write-Host "   - MCPs opt-in:  $([bool]$WithOptionalMcps)`n" -ForegroundColor White
}
finally {
    if ($TempCloneDir -and (Test-Path $TempCloneDir)) {
        Remove-Item -Path $TempCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
