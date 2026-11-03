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
