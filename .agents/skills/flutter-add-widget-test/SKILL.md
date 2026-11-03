---
name: flutter-add-widget-test
description: Criação de Widget Tests determinísticos em Flutter validando os 4 estados da UI, interações de toque, digitação e acessibilidade.
category: Qualidade & Testes
---

# Skill: Flutter Widget Testing

## 1. Diretrizes de Teste de Interface
- Envolva o widget testado em `MaterialApp` (e `ProviderScope` se usar Riverpod) com overrides dos repositórios falsos (`FakeRepository`).
- Teste explicitamente:
  1. Renderização do estado de carregamento.
  2. Renderização da lista preenchida e formatação correta de moeda (`R$`).
  3. Renderização do estado vazio quando a busca não retorna itens.
  4. Interação de clique (`tester.tap`) e abertura de modais/bottom sheets (`tester.pumpAndSettle`).
