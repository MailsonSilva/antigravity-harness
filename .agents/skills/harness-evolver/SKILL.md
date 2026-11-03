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
