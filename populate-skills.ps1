# ==============================================================================
# Antigravity Harness - Populador Nativo de Skills Profundas (Windows PowerShell)
# Cria todas as pastas em .agents/skills/ e grava o conteúdo técnico completo
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   🚀 Populador de Skills Profundas para Flutter     " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

function Write-SkillFile {
    param (
        [string]$SkillFolder,
        [string]$Content
    )
    $dir = Join-Path ".agents\skills" $SkillFolder
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $filePath = Join-Path $dir "SKILL.md"
    Set-Content -Path $filePath -Value $Content.Trim() -Encoding UTF8
    Write-Host "✔ Gravada skill profunda: $SkillFolder\SKILL.md" -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 1. CLEAN ARCHITECTURE
# ------------------------------------------------------------------------------
$cleanArch = @'
---
name: clean-architecture
description: Arquitetura Limpa em Flutter com separação estrita Presentation, Domain e Data, Domain Services puros e tratamento funcional de erros com sealed classes.
category: Engenharia de Software
---

# Skill: Clean Architecture & Domain Purity (Flutter/Dart 3)

## 1. Quando Acionar Esta Skill
Acione sempre que criar uma nova feature, refatorar regras de negócio espalhadas em Widgets/Controllers ou corrigir divergências de cálculo comercial entre telas (ex: pesquisa vs pedido).

## 2. Topologia de Pastas por Feature
```text
lib/features/<feature_name>/
├── domain/
│   ├── entities/          # Objetos imutáveis de negócio (100% Dart puro)
│   ├── repositories/      # Interfaces abstratas (contratos)
│   ├── services/          # Regras comerciais complexas (ex: PrecoDomainService)
│   └── failures/          # Sealed classes de falhas de domínio
├── data/
│   ├── datasources/       # LocalDataSource (SQLite) e RemoteDataSource (REST/Supabase)
│   ├── models/            # DTOs com fromJson/toJson e fromMap/toMap + toEntity()
│   └── repositories/      # Implementação concreta dos contratos de domain
└── presentation/
    ├── controllers/       # Notifiers / AsyncNotifiers (Riverpod)
    ├── pages/             # Scaffolds de tela
    └── widgets/           # Componentes visuais desacoplados e const
```

## 3. Regras Inegociáveis (Guardrails)
1. **Regra da Dependência**: `presentation` -> `domain` <- `data`. O diretório `domain` NUNCA importa pacotes de UI (`package:flutter/material.dart`) nem pacotes de banco/rede (`sqflite`, `dio`, `supabase_flutter`).
2. **Centralização de Cálculos**: É proibido calcular preços, descontos, impostos ou saldos dentro de `Widget.build()` ou dentro de queries SQL duplicadas. Crie um `DomainService` testável.
3. **Model vs Entity**: `Model` conhece JSON e colunas do SQLite (`pro00_codigo`). `Entity` usa nomes semânticos do domínio (`idProduto`, `precoBase`) e valida invariantes no construtor.

## 4. Padrão de Código Canônico (Dart 3 Sealed Result & Domain Service)
```dart
// domain/failures/result.dart
sealed class Result<T> {
  const Result();
}
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}
final class Failure<T> extends Result<T> {
  final String message;
  final String code;
  const Failure(this.message, {this.code = 'DOMAIN_ERROR'});
}

// domain/services/preco_calculator_service.dart
class PrecoCalculatorService {
  const PrecoCalculatorService();

  double calcularPrecoFinal({
    required double precoTabela,
    required double fatorPlanoPagamento,
    required double multiplicadorEmbalagem,
    double percentualDesconto = 0,
  }) {
    final fator = fatorPlanoPagamento > 0 ? fatorPlanoPagamento : 1.0;
    final mult = multiplicadorEmbalagem > 0 ? multiplicadorEmbalagem : 1.0;
    final bruto = precoTabela * fator * mult;
    final comDesconto = bruto * (1 - (percentualDesconto / 100));
    return double.parse(comDesconto.toStringAsFixed(2));
  }
}
```

## 5. Antipadrões Proibidos
- ❌ Chamar `DatabaseHelper.instance.query(...)` diretamente de dentro de um `StatefulWidget`.
- ❌ Retornar `Map<String, dynamic>` cru do repositório para a camada de UI.
- ❌ Silenciar exceções com `catch (e) { return []; }` sem propagar `Failure` para o estado da tela.
'@
Write-SkillFile -SkillFolder "clean-architecture" -Content $cleanArch

# ------------------------------------------------------------------------------
# 2. LOCAL FIRST DATA & SQLITE
# ------------------------------------------------------------------------------
$localData = @'
---
name: local-first-data
description: Engenharia Offline-First com SQLite em Flutter: indexação composta, buscas paginadas sem travamento de UI, debounce e sincronização em lote (Batch).
category: Dados & Offline
---

# Skill: Local-First SQLite & High-Performance Sync

## 1. Quando Acionar Esta Skill
Acione ao criar ou otimizar tabelas SQLite locais, implementar barras de pesquisa em catálogos grandes (> 5.000 itens), processar cargas offline (arquivos FTP/ZIP/JSON) ou resolver lentidão de leitura.

## 2. Regras de Ouro de Performance SQLite
1. **Zero Full Table Scan**: Toda coluna utilizada em `WHERE`, `JOIN` ou `ORDER BY` deve ter índice criado na migração (`CREATE INDEX IF NOT EXISTS`).
2. **Paginação Obrigatória**: Nunca carregue milhares de linhas na memória RAM do aparelho. Use sempre `LIMIT :limit OFFSET :offset` (padrão: 30 a 50 itens por página).
3. **Projeção Enxuta**: Nas listagens e buscas, selecione apenas as colunas visíveis no card (`SELECT id, nome, preco, estoque`). Deixe campos pesados (observações longas, metadados fiscais) para a query de detalhes do item.
4. **Inserção em Lote (Batch Transaction)**: Ao sincronizar dados recebidos do servidor, nunca execute `await db.insert()` dentro de um `for` simples. Use `db.transaction` com `batch.insert` e `batch.commit(noResult: true)`.

## 3. Padrão Canônico de Índices e Query Paginada
```dart
// 1. Criação de Índices na abertura/migração do banco
Future<void> ensurePerformanceIndexes(Database db) async {
  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_produtos_busca 
    ON cadpro00 (pro00_descri, pro00_codbar, pro00_codfab);
  ''');
  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_estoque_filial_prod 
    ON estpro00 (pro00_codfil, pro00_codpro);
  ''');
}

// 2. Busca Paginada Rápida com Filtro Parametrizado
Future<List<Map<String, Object?>>> buscarProdutosPaginado({
  required Database db,
  required int codFilial,
  required String termo,
  int limit = 30,
  int offset = 0,
}) async {
  final filtro = '%${termo.trim()}%';
  return db.rawQuery('''
    SELECT 
      p.pro00_codigo,
      p.pro00_descri,
      p.pro00_codbar,
      p.pro00_mulemb,
      COALESCE(e.pro00_qtdest - e.pro00_qtdpen, 0) AS estoque_disponivel
    FROM cadpro00 p
    LEFT JOIN estpro00 e 
      ON e.pro00_codpro = p.pro00_codigo AND e.pro00_codfil = ?
    WHERE p.pro00_descri LIKE ? 
       OR p.pro00_codbar LIKE ? 
       OR CAST(p.pro00_codigo AS TEXT) = ?
    ORDER BY p.pro00_descri ASC
    LIMIT ? OFFSET ?
  ''', [codFilial, filtro, filtro, termo.trim(), limit, offset]);
}
```

## 4. Debounce na Camada de Apresentação
Nunca dispare query no SQLite a cada tecla pressionada (`onChanged`). Aplique um Debouncer de 300ms a 350ms e cancele requisições obsoletas.
'@
Write-SkillFile -SkillFolder "local-first-data" -Content $localData

# ------------------------------------------------------------------------------
# 3. FLUTTER STATE RIVERPOD
# ------------------------------------------------------------------------------
$riverpod = @'
---
name: flutter-state-riverpod
description: Gerenciamento de estado reativo, previsível e testável em Flutter usando Riverpod (Notifier, AsyncNotifier, paginação e descarte automático).
category: Engenharia Mobile
---

# Skill: Reactive State Management com Riverpod

## 1. Diretrizes Técnicas
1. **Prefira `AsyncNotifier` e `Notifier`**: Evite `StateNotifierProvider` e `ChangeNotifierProvider` legados.
2. **Imutabilidade**: O estado exposto deve ser imutável (`final` fields + método `copyWith`).
3. **Sem Lógica de UI no Notifier**: Nunca passe `BuildContext`, `TextEditingController` ou `Navigator` para dentro de um Notifier.
4. **Uso de `ref.watch` vs `ref.read`**:
   - Dentro do método `build()`: use SEMPRE `ref.watch(provider)`.
   - Dentro de callbacks (`onPressed`, `onSubmitted`): use SEMPRE `ref.read(provider.notifier).acao()`.

## 2. Padrão Canônico de State Imutável
```dart
class CatalogoState {
  final List<ProdutoEntity> itens;
  final bool carregandoMais;
  final bool temMais;
  final String termoBusca;

  const CatalogoState({
    this.itens = const [],
    this.carregandoMais = false,
    this.temMais = true,
    this.termoBusca = '',
  });

  CatalogoState copyWith({
    List<ProdutoEntity>? itens,
    bool? carregandoMais,
    bool? temMais,
    String? termoBusca,
  }) {
    return CatalogoState(
      itens: itens ?? this.itens,
      carregandoMais: carregandoMais ?? this.carregandoMais,
      temMais: temMais ?? this.temMais,
      termoBusca: termoBusca ?? this.termoBusca,
    );
  }
}
```
'@
Write-SkillFile -SkillFolder "flutter-state-riverpod" -Content $riverpod

# ------------------------------------------------------------------------------
# 4. MOBILE UX & DESIGN SYSTEM
# ------------------------------------------------------------------------------
$mobileUx = @'
---
name: mobile-ux
description: Engenharia de Experiência do Usuário Mobile em Flutter: Material 3, Design Tokens, 4 estados obrigatórios de tela, ergonomia de toque (48dp) e micro-interações.
category: UI/UX & Frontend
---

# Skill: Mobile UX, Ergonomia & Design Systems

## 1. Os 4 Estados Obrigatórios de Qualquer Tela ou BottomSheet
Nenhuma tela está pronta se apenas o caminho feliz foi desenhado. Implemente obrigatoriamente:
1. **Estado Loading**: Skeleton / Shimmer que preserva a geometria do card real, evitando saltos de layout (Layout Shift).
2. **Estado Empty (Vazio)**: Ícone semântico, título claro ("Nenhum produto encontrado para 'X'") e botão para limpar filtros.
3. **Estado Error (Falha)**: Card informativo com o motivo claro e botão de retentativa (`onRetry`).
4. **Estado Success (Dados)**: Hierarquia tipográfica clara (Título em destaque, código/embalagem secundários, preço final em evidência e badge de estoque colorido).

## 2. Checklist de Ergonomia e Acessibilidade
- [ ] Alvos de toque (`IconButton`, `InkWell`, chips) possuem no mínimo `48x48dp`.
- [ ] Campos numéricos (quantidade, desconto, preço) abrem teclado numérico apropriado (`TextInputType.numberWithOptions(decimal: true)`) e selecionam o texto ao receber foco.
- [ ] Listas com scroll fecham o teclado automaticamente ao arrastar (`keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`).
- [ ] Textos dinâmicos usam `maxLines` e `TextOverflow.ellipsis` dentro de `Expanded`/`Flexible` para jamais causar erro de faixa amarela/preta (`RenderFlex overflowed`).
'@
Write-SkillFile -SkillFolder "mobile-ux" -Content $mobileUx

# ------------------------------------------------------------------------------
# 5. CODE QUALITY & STRICT TDD
# ------------------------------------------------------------------------------
$codeQuality = @'
---
name: code-quality-tests
description: TDD estrito (Red-Green-Refactor), testes unitários de serviços de domínio, isolamento de SQLite em memória (sqflite_common_ffi) e contratos anti-regressão.
category: Qualidade & Testes
---

# Skill: Strict TDD & Isolamento de Testes em Flutter

## 1. Fluxo Obrigatório Red-Green-Refactor
1. **RED**: Crie o arquivo `*_test.dart` reproduzindo o bug ou validando o novo requisito. Rode `flutter test <caminho>` e confirme que FALHOU.
2. **GREEN**: Escreva o código de produção mínimo para satisfazer o teste.
3. **REFACTOR**: Elimine duplicações, rode `dart analyze` e confirme 0 warnings.

## 2. Regra Crítica para Testes com SQLite (`sqflite_common_ffi`)
Nunca compartilhe o mesmo arquivo `.db` físico entre testes paralelos (isso causa `database is locked`). Use banco em memória isolado por cada teste:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await criarSchemaDeTeste(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Deve calcular o mesmo preço na listagem e no detalhe do produto', () async {
    // Arrange, Act, Assert
  });
}
```
'@
Write-SkillFile -SkillFolder "code-quality-tests" -Content $codeQuality

# ------------------------------------------------------------------------------
# 6. WIDGET TEST
# ------------------------------------------------------------------------------
$widgetTest = @'
---
name: flutter-add-widget-test
description: Criação de Widget Tests determinísticos em Flutter validando os 4 estados da UI, interações de toque, digitação e acessibilidade.
category: Qualidade & Testes
---

# Skill: Flutter Widget Testing

## 1. Diretrizes de Teste de Interface
- Envolva o widget testado em `MaterialApp` (e `ProviderScope` se usar Riverpod) com overrides dos repositórios falsos (`FakeRepository`).
- Teste explicitamente:
  1. Renderização do estado de carregamento.
  2. Renderização da lista preenchida e formatação correta de moeda (`R$`).
  3. Renderização do estado vazio quando a busca não retorna itens.
  4. Interação de clique (`tester.tap`) e abertura de modais/bottom sheets (`tester.pumpAndSettle`).
'@
Write-SkillFile -SkillFolder "flutter-add-widget-test" -Content $widgetTest

# ------------------------------------------------------------------------------
# 7. RESPONSIVE LAYOUT
# ------------------------------------------------------------------------------
$responsive = @'
---
name: flutter-build-responsive-layout
description: Construção de layouts adaptativos e responsivos em Flutter para smartphones pequenos, grandes e tablets usando LayoutBuilder, MediaQuery.sizeOf e Slivers.
category: UI/UX & Frontend
---

# Skill: Responsive & Adaptive Layouts em Flutter

## 1. Regras de Responsividade
1. **Use `MediaQuery.sizeOf(context)`** em vez de `MediaQuery.of(context).size` para evitar rebuilds desnecessários quando o teclado abre.
2. **Breakpoints Canônicos**:
   - Compacto (Celular): `< 600dp` (Lista em 1 coluna, BottomNavigationBar).
   - Médio (Tablet Vertical / Dobrável): `600dp – 839dp` (Grid de 2 colunas, NavigationRail).
   - Expandido (Tablet Horizontal / Desktop): `>= 840dp` (Layout Master-Detail lado a lado).
3. **Prevenção de Overflow em Modais/BottomSheets**: Todo `BottomSheet` com campos de texto deve envolver seu conteúdo em `SingleChildScrollView` + `Padding(padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom))`.
'@
Write-SkillFile -SkillFolder "flutter-build-responsive-layout" -Content $responsive

# ------------------------------------------------------------------------------
# 8. DART PATTERN MATCHING
# ------------------------------------------------------------------------------
$patternMatching = @'
---
name: dart-use-pattern-matching
description: Uso avançado de Dart 3: Records, Sealed Classes, Switch Expressions exaustivas, Destructuring e If-Case para código seguro e conciso.
category: Engenharia Mobile
---

# Skill: Dart 3 Pattern Matching & Modern Syntax

## 1. Quando Usar
- Substituir hierarquias verbosas de `if/else` por `switch` expressions exaustivas sobre `sealed class`.
- Desestruturar JSONs ou tuplas retornadas de consultas combinadas usando `Records`.

```dart
Widget buildStatusBadge(StatusPedido status) {
  return switch (status) {
    PedidoRascunho() => const Chip(label: Text('Rascunho')),
    PedidoSincronizando(:final progresso) => CircularProgressIndicator(value: progresso),
    PedidoTransmitido(:final numeroErp) => Chip(label: Text('ERP #$numeroErp')),
    PedidoComErro(:final motivo) => Tooltip(message: motivo, child: const Icon(Icons.error)),
  };
}
```
'@
Write-SkillFile -SkillFolder "dart-use-pattern-matching" -Content $patternMatching

# ------------------------------------------------------------------------------
# 9. SUPABASE FLUTTER
# ------------------------------------------------------------------------------
$supabase = @'
---
name: supabase-flutter
description: Arquitetura segura com Supabase em Flutter: Auth, políticas Row Level Security (RLS), sincronização offline/online, RPCs e Storage.
category: Backend & Cloud
---

# Skill: Supabase Fullstack & RLS Architecture

## 1. Guardrails Obrigatórios
1. **RLS Sempre Ativo**: Nenhuma tabela no schema `public` pode existir sem `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`.
2. **Operações Atômicas via RPC**: Para operações financeiras ou fechamento de pedidos que alteram múltiplas tabelas, crie uma PostgreSQL Function (`rpc`) transacional em vez de fazer várias requisições seguidas pelo cliente mobile.
3. **Sincronização Incremental**: Use colunas `updated_at` indexadas para puxar apenas os registros modificados desde o último timestamp de sincronização (`gt('updated_at', lastSyncIso)`).
'@
Write-SkillFile -SkillFolder "supabase-flutter" -Content $supabase

# ------------------------------------------------------------------------------
# 10. SPEC DISCOVERY
# ------------------------------------------------------------------------------
$specDiscovery = @'
---
name: spec-discovery
description: Descoberta técnica estruturada e geração de PRD/Spec com mapeamento de contratos de dados, regras fiscais/comerciais e critérios de aceitação Gherkin.
category: Arquitetura & Produto
---

# Skill: Spec-Driven Discovery & Architecture Contract

## 1. Estrutura Obrigatória de Toda Spec (`_specs/features/<nome>.md`)
Toda especificação gerada pelo `master_orchestrator` deve conter:
1. **Contexto e Problema Real**: O que está quebrado, lento ou faltando.
2. **Arquivos e Tabelas Impactadas**: Lista mapeada via `graft_ast`.
3. **Contrato de Domínio / Fórmula**: Fórmulas matemáticas ou regras de negócio explícitas.
4. **Os 4 Estados Visuais**: Como a tela se comporta em Loading, Empty, Error e Success.
5. **Cenários de Teste (Dado / Quando / Então)**: Lista objetiva que o `tdd_specialist` transformará em testes automatizados.
'@
Write-SkillFile -SkillFolder "spec-discovery" -Content $specDiscovery

# ------------------------------------------------------------------------------
# 11. HARNESS EVOLVER
# ------------------------------------------------------------------------------
$harnessEvolver = @'
---
name: harness-evolver
description: Ciclo recursivo Propose-Probe-Compose do Google Research Harness² para atualizar automaticamente as skills e regras após resolução de bugs complexos.
category: Meta-Otimização
---

# Skill: Google Harness² Recursive Self-Improvement

## 1. Protocolo Propose–Probe–Compose
Sempre que uma tarefa reprovar no Gate Humano ou exigir mais de 1 tentativa de autorreparo no `qa_self_healer`:
1. **PROPOSE**: Identifique qual lacuna de instrução permitiu que o erro acontecesse (ex: faltou uma regra sobre lock de banco ou conversão de tipo nulo).
2. **PROBE**: Valide a correção no código e confirme que todos os testes passam.
3. **COMPOSE**: Adicione uma subseção `## Armadilhas Conhecidas (Learned Guardrails)` no final da `SKILL.md` correspondente ou em `.agents/PROJECT_BRAIN.md`, documentando o antipadrão evitado.
'@
Write-SkillFile -SkillFolder "harness-evolver" -Content $harnessEvolver

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "  🎉 Todas as Skills Profundas foram geradas!        " -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green