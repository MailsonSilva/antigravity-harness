# Workflow: Orquestração e Execução Concorrente (Argon / Hydrogen)

**Modelo Coordenador**: Gemini 4 Argon (Orquestrador de execução crítica e resolução de conflitos).
**Modelos dos Workers**: Gemini 4 Hydrogen (Execução rápida, pontual e paralela).
**Pré-requisito**: Arquivo `_specs/SPEC.md` aprovado na fase Carbon.

---

## 1. Papel do Orquestrador Argon
- Ler `_specs/SPEC.md` e extrair a lista de tarefas atômicas independentes (`TASK-01`, `TASK-02`, etc.).
- Sincronizar as tarefas extraídas em `_specs/board.json` (`schemaVersion: 1`, `lastModified` ISO-8601, `column: "backlog"`).
- Organizar as tarefas em ondas de execução baseadas em dependências:
  - **Onda 1 (Base)**: Contratos, Entidades de Domínio, Migrations de Banco ou Schemas de Dados.
  - **Onda 2 (Implementação Paralela)**: Repositórios, Data Sources e Componentes de UI desacoplados.
  - **Onda 3 (Integração & Estado)**: Controllers/Notifiers, montagem de telas e injeção de dependências.
  - **Onda 4 (Qualidade)**: Bateria de testes automatizados e suíte de regressão.
- Ao iniciar uma onda, mover as tarefas em execução em `_specs/board.json` para `red`/`green` conforme o estágio e atualizar `lastModified`.

---

## 2. Protocolo de Despacho para Subagentes Hydrogen

### Configuração do Despacho
Para cada tarefa elegível da onda atual:
1. Invoque um subagente via `invoke_subagent` com `TypeName: "self"` ou role especializado, com `Workspace: "branch"` ou `"inherit"` (se arquivos forem estritamente disjuntos).
2. Forneça um briefing focado:
   ```markdown
   Você é um executor Hydrogen para a tarefa: [TASK-ID: Nome].
   Arquivos alvo:
   - [caminho/do/arquivo_1]
   - [caminho/do/arquivo_2]

   Instruções:
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
1. Atualizar o checklist da `_specs/SPEC.md` e mover as tarefas concluídas em `_specs/board.json` para `done` (atualizando `lastModified`).
2. Apresentar ao usuário o relatório final:
   - Arquivos alterados.
   - Evidência dos comandos de teste e lint (código de saída 0).
   - Próximos passos recomendados.
