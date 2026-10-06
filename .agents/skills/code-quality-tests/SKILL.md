---
name: code-quality-tests
description: Automação de testes unitários, testes de integração e revisão estática para aplicações Web modernas (Next.js, React, TypeScript). Use para gerar testes, validar regras de negócio e garantir cobertura antes de commits.
---

# Code Quality & Tests (Web / Next.js)

Diretrizes para garantia de qualidade e estabilidade de código em ambientes Web e Next.js.

## Princípios de Testes
1. **Pirâmide Focada:** Priorize testes de regras de domínio e funções utilitárias puras. Para componentes visuais, teste comportamento do usuário em vez de implementação interna.
2. **Server Components vs Client Components:**
   - Server Actions e rotas de API: Teste entradas, validação de schema (Zod) e saídas/erros esperados.
   - Client Components: Utilize mocks para chamadas assíncronas e foque nos estados de loading, erro e sucesso.

## Checklist Pré-Entrega
- [ ] Executar type-check (`npm run type-check` ou `tsc --noEmit`).
- [ ] Validar linting (`npm run lint`).
- [ ] Criar/atualizar testes unitários para a funcionalidade recém-adicionada (`npm run test`).