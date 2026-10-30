---
name: harness-evolver
description: Implementa o ciclo recursivo Propose-Probe-Compose do Google Research Harness² para autoaperfeiçoamento contínuo das skills e diretrizes operacionais.
---

# Skill: Harness Recursive Self-Improvement (Propose–Probe–Compose)

Esta skill orienta o agente na autoevolução do ecossistema `.agents/` sempre que um ciclo de desenvolvimento encontrar arestas ou demandar autorreparo.

## 1. Gatilho de Ativação
Acionada automaticamente quando:
- Um ciclo de autorreparo de QA exigir 2 ou mais iterações para passar.
- Um bug corrigido for identificado como reincidente.
- Uma nova biblioteca for adicionada ao projeto sem diretriz prévia.

## 2. O Ciclo Propose–Probe–Compose
1. **Propose (Proposta de Ajuste no Harness)**:
   - Identifique a causa raiz da falha ou lentidão.
   - Formule uma regra preventiva clara para a respectiva skill em `.agents/skills/` ou adicione uma trava em `.agents/rules/`.
2. **Probe (Validação Experimental)**:
   - Execute a suíte de testes do projeto para certificar que a nova diretriz não introduz contradições nem quebra fluxos válidos.
3. **Compose (Consolidação Permanente)**:
   - Grave a adição defensiva no arquivo `.md` correspondente.
   - Registre o aprendizado na seção de histórico do `.agents/PROJECT_BRAIN.md`.
