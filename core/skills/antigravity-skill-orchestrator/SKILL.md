---
name: antigravity-skill-orchestrator
description: Meta-orquestrador cognitivo para triagem de tarefas e ativação progressiva de skills. Avalia complexidade antes de delegar para evitar inchaço de contexto e chamadas desnecessárias. Use sempre no início de tarefas complexas ou fluxos de desenvolvimento.
---

# Antigravity Skill Orchestrator

Você atua como o avaliador prévio de execução no harness. Seu papel é impedir o desperdício de tokens, selecionar as skills certas e delegar para subagentes nativos (`invoke_subagent`) com briefing focado.

## Regras de Triagem

1. **Alterações Elementares (Low Complexity):**
   - Correções simples de sintaxe, ajustes pontuais de tema/widgets, renomeação de variáveis ou adição de tipagens triviais.
   - **Ação:** NÃO ative skills adicionais nem dispare subagentes. Execute diretamente com `edit_file`.

2. **Planejamento de Funcionalidade ou Refatoração Estrutural:**
   - Criação de novas features, telas, fluxos de navegação ou integração de fontes de dados.
   - **Ação:** Ative `spec-discovery` e/ou `clean-architecture` (ou delegue com `invoke_subagent`).

3. **Performance Mobile (Flutter):**
   - Rebuilds excessivos, jank em listas/animações, tamanho do app elevado ou descarte de quadros.
   - **Ação:** Ative `clean-architecture` com apoio de `mobile-ux`.

4. **Validação e Entrega:**
   - Criação de testes unitários/integração, lint, cobertura ou preparação para release.
   - **Ação:** Ative `code-quality-tests` (e/ou `dart-collect-coverage`, `flutter-release`).

## Tabela de Roteamento (tarefa → subagente Antigravity + skills)

Ao delegar via `invoke_subagent`, use **sempre** um `TypeName` nativo (`"self"` para edição/execução, `"research"` para leitura/descoberta) com o `Role` abaixo, e instrua o subagente no `Prompt` a ler `.agents/skills/<skill>/SKILL.md` (no máximo 2 skills por delegação).

| Tarefa | `TypeName` | `Role` Sugerido | Skills (ordem de prioridade) |
|---|---|---|---|
| Descobrir escopo, PRD, regras de negócio | `research` | `Product Discovery Analyst` | `spec-discovery` |
| Protótipo visual, tokens, UX mobile | `self` | `Flutter UI/UX Designer` | `mobile-ux` |
| Breakpoints e telas grandes | `self` | `Flutter Responsive Builder` | `flutter-build-responsive-layout`, `mobile-ux` |
| Inventário de strings / i18n | `self` | `Flutter Localization Engineer` | `flutter-setup-localization` |
| Estruturar camadas / pureza de domínio | `self` | `Flutter Clean Arch Architect` | `clean-architecture` |
| Implementar feature (Services/Notifiers) | `self` | `Flutter Feature Builder` | `flutter-apply-architecture-best-practices`, `flutter-state-riverpod` |
| Modelos/DTOs/Providers gerados (build_runner) | `self` | `Flutter Codegen Engineer` | `flutter-code-generation`, `flutter-apply-architecture-best-practices` |
| Estado com Riverpod / 4 estados | `self` | `Flutter Riverpod Engineer` | `flutter-state-riverpod`, `mobile-ux` |
| Navegação, rotas, deep links | `self` | `Flutter Routing Engineer` | `flutter-setup-declarative-routing` |
| Ambientes, flavors e segurança | `self` | `Flutter Security & Env Engineer` | `flutter-environments-security` |
| APIs REST de produção (Dio/refresh/retry) | `self` | `Flutter Network Engineer` | `flutter-networking-dio`, `local-first-data` |
| Chamadas HTTP simples/pontuais | `self` | `Flutter Network Engineer` | `flutter-use-http-package` |
| Supabase (auth, RLS, storage) | `self` | `Supabase Flutter Engineer` | `supabase-flutter`, `local-first-data` |
| Banco local, sync offline | `self` | `Offline-First Data Engineer` | `local-first-data`, `supabase-flutter` |
| Refatorar if-else/JSON/sealed | `self` | `Dart Pattern Matching Engineer` | `dart-use-pattern-matching`, `clean-architecture` |
| Testes RED (unit/widget) | `self` | `Flutter TDD Tester` | `clean-architecture`, `flutter-add-widget-test` |
| Testes visuais / Golden Tests | `self` | `Flutter Golden Test Engineer` | `flutter-golden-tests`, `flutter-add-widget-test` |
| Teste E2E em device | `self` | `Flutter Integration Tester` | `flutter-add-integration-test`, `code-quality-tests` |
| QA, lint, cobertura, autorreparo | `self` | `Flutter QA & Coverage Validator` | `code-quality-tests`, `dart-collect-coverage` |
| Observabilidade, crashes e pós-deploy | `self` | `Flutter Observability Engineer` | `flutter-observability`, `harness-evolver` |
| Release, CI/CD e publicação | `self` | `Flutter Release Engineer` | `flutter-release`, `mobile-cicd`, `store-publishing` |
| Commit semântico | `self` | `Git Release Committer` | (nenhuma — usa `git diff` e pt-BR) |

## Protocolo de Decisão
- Nunca carregue mais de duas skills simultaneamente no mesmo turno ou subagente.
- No `Prompt` de todo `invoke_subagent`, inclua explicitamente: *"Leia `.agents/skills/<skill>/SKILL.md` antes de executar."*
- Garanta que as regras contidas em `GEMINI.md` na raiz do projeto sejam o teto máximo de conformidade.
