# Diretrizes Específicas: Flutter (Mobile & SaaS Offline-First)

---

## 1. Arquitetura de Camadas (Clean / MVVM)
Adote estrutura modular estrita por feature:

```text
lib/
├── core/                  # Serviços globais, DB local, tema e utilitários
│   ├── config/            # AppEnv (--dart-define-from-file)
│   ├── database/          # SQLite (migrations, helpers, DAOs)
│   ├── network/           # Clientes Dio / HTTP / Supabase SDK
│   ├── observability/     # CrashReporter (Sentry/Crashlytics) e handlers globais
│   └── theme/             # Design Tokens, tipografia e estilos
├── features/
│   └── [feature_name]/
│       ├── data/          # Models, DTOs (.freezed/.g), DataSources e Repositórios concretos
│       ├── domain/        # Entidades puras e Interfaces de repositório
│       └── presentation/  # Telas, Widgets e AsyncNotifiers
└── main.dart
```

### Regras de Dependência
- **Domain**: Dart puro, sem imports de Flutter, widgets ou pacotes externos de UI/rede/banco.
- **Presentation**: Depende exclusivamente do Domain e de seus próprios Notifiers/Controllers. Nunca chama SQLite ou APIs diretamente do Widget.
- **Data**: Implementa as interfaces do Domain, tratando mapeamentos, erros e cache local.

---

## 2. Padrão dos 4 Estados de UI
Todo ecrã ou componente que consome dados assíncronos deve tratar explicitamente:
1. **Loading**: Indicador de progresso ou shimmer skeleton contextual.
2. **Empty**: Mensagem amigável + Call to Action claro para inclusão do primeiro item.
3. **Error**: Mensagem clara em pt-BR + botão obrigatório de "Tentar Novamente".
4. **Success**: Renderização limpa dos dados, com paginação ou scroll infinito sob demanda.

---

## 3. Persistência Offline-First (SQLite Local)
- **Migrations Versionadas**: Nunca altere a estrutura do banco em produção diretamente; use scripts de migração sequenciais no `onUpgrade`.
- **Índices Compostos**: Adicione índices para colunas usadas frequentemente em filtros (`WHERE`), ordenações (`ORDER BY`) ou chaves estrangeiras.
- **Operações em Lote**: Mutações em massa devem rodar dentro de transações com `batch.commit(noResult: true)`.
- **Testes em Memória**: Repositórios e DAOs locais devem ser testados via `sqflite_common_ffi` com `databaseFactoryFfi` (sem necessidade de emulador físico).

---

## 4. Ergonomia, Design System e UI Mobile (Regra Inegociável)
- **Fonte Única Visual:** É **obrigatório** ler `_references/brand/DESIGN_SYSTEM.md` antes de criar ou editar qualquer widget ou tela.
- **Proibição Estrita de Valores Hardcoded em `lib/features/`:** É **estritamente proibido** usar cores literais (`Color(0x...)`, `Colors.blue`, etc., exceto `Colors.transparent`), `TextStyle` com `fontSize`/`fontFamily` hardcoded ou números mágicos de espaçamento/borda diretamente em `lib/features/`. Tudo deve vir de `Theme.of(context)` (`colorScheme`, `textTheme`) ou `ThemeExtension` (`context.tokens` em `lib/core/theme/`).
- **Área Mínima de Toque**: Todo elemento interativo deve ter no mínimo **48x48 dp**.
- **Performance**: Use construtores `const` sempre que o widget não contiver estado mutável.

---

## 5. Gatilhos de Skills por Etapa do Ciclo
- **Camadas & Fluxo**: `clean-architecture` (fronteiras/Result) + `flutter-apply-architecture-best-practices` (Services/Notifiers).
- **Design System & UX**: `flutter-design-system` (`lib/core/theme/` e `ThemeExtension`) + `mobile-ux` (4 estados e ergonomia 48dp).
- **Codegen**: `flutter-code-generation` sempre que usar `freezed`, `json_serializable` ou `@riverpod` (`build_runner`).
- **Rede**: `flutter-networking-dio` como padrão de produção (interceptors/refresh/retry); `flutter-use-http-package` só para chamadas simples/pontuais.
- **Ambientes & Secrets**: `flutter-environments-security` para flavors (`dev`, `staging`, `prod`), `--dart-define-from-file` e `.gitignore`.
- **Qualidade & Regressão Visual**: `flutter-add-widget-test`, `flutter-golden-tests` (contra `_references/screens/`) e `flutter-add-integration-test` (Patrol).
- **Observabilidade Pós-Deploy**: `flutter-observability` (`FlutterError.onError`, `PlatformDispatcher.instance.onError`, Sentry/Crashlytics e retroalimentação para `PROJECT_BRAIN.md` / `HARNESS_FEEDBACK.md`).

---

## 6. Loop Obrigatório de Verificação (Flutter Gate)
Antes de finalizar qualquer tarefa ou PR, execute o gate unificado (ou os comandos abaixo):
```powershell
# Windows (PowerShell)
.\.agents\scripts\verify.ps1
```
```bash
# Linux / macOS / CI
./.agents/scripts/verify.sh
```
Equivalente manual: `dart format .`, `dart analyze` (0 avisos) e `flutter test -j 1` (100% verde). Proibido concluir tarefas se a análise estática reportar avisos ou se qualquer teste falhar.
