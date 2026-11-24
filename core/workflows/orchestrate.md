# Workflow: Orquestração e Execução Concorrente (Argon / Hydrogen)

**Modelo Coordenador**: Gemini 4 Argon (Orquestrador de execução crítica e resolução de conflitos).
**Modelos dos Workers**: Gemini 4 Hydrogen (Execução rápida, pontual e paralela).
**Pré-requisito**: Arquivo `_specs/SPEC.md` aprovado na fase Carbon.

---

## 1. Papel do Orquestrador Argon
- Ler `_specs/SPEC.md` e extrair as tarefas atômicas (`TASK-01`, `TASK-02`, etc.) e os **Guardrails Negativos (Não Tocar)**.
- Sincronizar as tarefas extraídas em `_specs/board.json` (`schemaVersion: 1`, `lastModified` ISO-8601, `column: "backlog"`).
- Organizar as tarefas em ondas TDD reais baseadas em dependências:
  - **Onda 1 (Base & Contratos)**: Entidades de Domínio, Interfaces de Repositório, Migrations ou Schemas de Dados.
  - **Onda 2 (Fase RED — TDD First)**: Subagentes criam os testes unitários/widget mapeados 1:1 dos critérios da `SPEC.md` e confirmam a falha inicial (mover tarefas para `"red"` em `_specs/board.json`).
  - **Onda 3 (Fase GREEN — Implementação Paralela)**: Subagentes implementam Repositórios, Data Sources, Controllers/Notifiers e UI mínima para passar nos testes da Onda 2 (mover tarefas para `"green"` em `_specs/board.json`).
  - **Onda 4 (Refactor & Gate de Verificação)**: Refatoração limpa, análise estática (`dart analyze` / `npm run lint`), suíte completa de testes e transição para `"review"` / `"done"`.
- Ao iniciar cada onda, atualizar a coluna correspondente em `_specs/board.json` e o campo `lastModified`.

---

## 2. Protocolo de Despacho para Subagentes Hydrogen

### Configuração do Despacho
Para cada tarefa elegível da onda atual:
1. Invoque um subagente via `invoke_subagent` com `TypeName: "self"` (ou `"research"` para exploração), com `Workspace: "branch"` ou `"inherit"` (se arquivos forem estritamente disjuntos).
2. Forneça um briefing focado:
   ```markdown
   Você é um executor Hydrogen para a tarefa: [TASK-ID: Nome].
   Arquivos alvo:
   - [caminho/do/arquivo_1]
   - [caminho/do/arquivo_2]

   Guardrails Negativos (Não Tocar):
   - [arquivos/módulos fora de escopo extraídos da SPEC.md]

   Instruções:
   - Leia `.agents/skills/<skill>/SKILL.md` antes de executar (se aplicável).
   - Implemente estritamente o escopo solicitado sem alterar arquivos fora do alvo.
   - Siga as regras em GEMINI.md.
   - Execute o teste unitário local correspondente antes de reportar.
   - Retorne apenas a lista de arquivos criados/modificados e o resultado do teste.
   ```

3. Emita as chamadas de invocação em lote para paralelizar a execução dos workers.

---

## 3. Consolidação e Gate de Verificação (Argon)
Após a conclusão dos subagentes de uma onda:
1. **Revisão de Diffs**: O Argon valida que nenhum worker sobrescreveu contratos ou violou a arquitetura.
2. **Execução do Verification Loop**:
   - Rodar análise estática global (`flutter analyze` ou `npm run lint`).
   - Rodar bateria de testes completa do módulo.
   - Rodar verificação de build se aplicável.
3. **Resolução de Falhas**:
   - Se houver erro de compilação ou teste vermelho, o Argon intervém diretamente ou despacha um Hydrogen corretivo com o stack trace exato.

---

## 4. Conclusão da Entrega
Quando todas as tarefas estiverem verdes e verificadas:
1. Atualizar o checklist da `_specs/SPEC.md`, mover as tarefas concluídas em `_specs/board.json` para `done` (atualizando `lastModified`) e atualizar o bloco `Último Handoff & Decisões Recentes` em `.agents/PROJECT_BRAIN.md` (substituindo itens obsoletos, sem acumular log infinito).
2. Se houve retrabalho ou lacuna de instrução durante as ondas, registrar uma sugestão (`Status: pendente`) em `.agents/HARNESS_FEEDBACK.md` para futura promoção ao `antigravity-harness`.
3. Apresentar ao usuário o relatório final:
   - Arquivos alterados.
   - Evidência dos comandos de teste e lint (código de saída 0).
   - Próximos passos recomendados.
