---
name: spec-discovery
description: Descoberta técnica estruturada (SDD) em formato de Micro-Spec com entrevista cirúrgica, guardrails negativos e mapeamento 1:1 de critérios de aceitação para testes RED.
category: Arquitetura & Produto
---

# Skill: Spec-Driven Discovery & Micro-Spec Contract

## 1. Princípio da Micro-Spec
- Cada especificação deve cobrir **uma fatia vertical** (legível em ~2 minutos) e ser salva em `_specs/SPEC.md`.
- Evite PRDs monolíticos: se houver mais de 5–7 tarefas atômicas, divida em incrementos menores.

## 2. Entrevista Cirúrgica & Design System Pré-Spec
Antes de fechar `_specs/SPEC.md` ou planejar telas:
1. **Verificação Visual Obrigatória (`_references/brand/DESIGN_SYSTEM.md`)**:
   - Confira se `_references/brand/DESIGN_SYSTEM.md` já está preenchido para o projeto.
   - Se ainda estiver no estado de template (`[Nome do App]`), extraia paleta, tipografia e estilos das referências em `_references/screens/` ou faça perguntas rápidas ao usuário para defini-lo antes de iniciar a UI.
2. Formule até **3 a 5 perguntas diretas** apenas para eliminar lacunas reais que não devem ser chutadas:
   - Transições de estado e comportamento offline/erro.
   - Contratos de dados, nulabilidade e regras de negócio/cálculo.
   - Limites de escopo (o que **não** deve ser alterado nesta entrega).

## 3. Estrutura Obrigatória de `_specs/SPEC.md`
1. **Contexto e Problema Real**: O que está quebrado, lento ou faltando.
2. **Contratos de Domínio, Dados e 4 Estados Visuais**: Entidades, tipos, fórmulas explícitas e comportamento da UI em `Loading`, `Empty`, `Error` e `Success`.
3. **Guardrails Negativos (Fora de Escopo / Não Tocar)**: Lista explícita de arquivos, módulos, rotas ou contratos existentes que os subagentes estão proibidos de alterar.
4. **Cenários de Aceitação (Dado / Quando / Então) → Testes RED (1:1)**: Cada cenário deve indicar explicitamente qual arquivo/caso de teste (`unit`, `widget` ou `integration_test`/`patrol`) provará o comportamento **antes** da implementação.
