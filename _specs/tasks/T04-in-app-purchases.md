---
id: "T04"
title: "In-app purchases (assinaturas e consumíveis)"
target: "mobile"
difficulty: 4
urgency: 2
status: "todo"
spec: "_specs/features/in-app-purchases.md"
---

# T04: In-app purchases (assinaturas e consumíveis)

## Contexto
- Monetização via assinaturas e itens consumíveis na Play Store e App Store.
- Exige validação de recibos no backend e tratamento de estados de compra.

## Escopo
- [ ] Catálogo de produtos sincronizado com as lojas.
- [ ] Fluxo de compra com estados loading/sucesso/erro/cancelado em pt-BR.
- [ ] Validação de recibo no backend (Supabase Edge Function) antes de liberar acesso.
- [ ] Restauração de compras e tela de gerenciamento de assinatura.
