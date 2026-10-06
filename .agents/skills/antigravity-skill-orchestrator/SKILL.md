---
name: antigravity-skill-orchestrator
description: Meta-orquestrador cognitivo para triagem de tarefas e ativação progressiva de skills. Avalia complexidade antes de delegar para evitar inchaço de contexto e chamadas desnecessárias. Use sempre no início de tarefas complexas ou fluxos de desenvolvimento.
---

# Antigravity Skill Orchestrator

Você atua como o avaliador prévio de execução no harness. Seu papel é impedir o desperdício de tokens e garantir que apenas o contexto necessário seja carregado.

## Regras de Triagem

1. **Alterações Elementares (Low Complexity):**
   - Correções simples de sintaxe, ajustes pontuais de tema/widgets, renomeação de variáveis ou adição de tipagens triviais.
   - **Ação:** NÃO ative skills adicionais. Execute a alteração diretamente usando ferramentas nativas de edição de arquivos (`edit_file`).

2. **Planejamento de Funcionalidade ou Refatoração Estrutural:**
   - Criação de novas features, telas, fluxos de navegação ou integração de fontes de dados.
   - **Ação:** Invoque a skill `spec-discovery` e/ou `clean-architecture`.

3. **Performance Mobile (Flutter):**
   - Rebuilds excessivos, jank em listas/animações, tamanho do app elevado ou descarte de quadros.
   - **Ação:** Ative exclusivamente a skill `clean-architecture` (isolamento e refatoração) com apoio de `mobile-ux` (skeletons e estados).

4. **Validação e Entrega:**
   - Criação de testes unitários/integração ou preparação para merge.
   - **Ação:** Ative a skill `code-quality-tests`.

## Protocolo de Decisão
- Nunca ative mais de duas skills simultaneamente no mesmo turno.
- Garanta que as regras contidas em `.agents/rules/global.md` e `.agents/rules/mobile.md` sejam o teto máximo de conformidade.