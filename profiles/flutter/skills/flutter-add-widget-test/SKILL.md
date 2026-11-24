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

## 2. Golden Tests e Prevenção de Regressão Visual
- **Prevenção de *overflow* e quebra responsiva:** valide widgets críticos e telas compostas em pelo menos dois viewports usando `tester.view.physicalSize` e `tester.view.devicePixelRatio = 1.0` (ex.: `Size(360, 640)` compacto e `Size(1024, 768)` tablet), resetando com `addTearDown(tester.view.resetPhysicalSize)`.
- **Comparação visual (`matchesGoldenFile`):** adicione `await expectLater(find.byType(MeuWidget), matchesGoldenFile('goldens/meu_widget.png'));` para componentes compartilhados e telas-chave.
- **Atualização controlada:** ao alterar intencionalmente o visual de um widget, regenere com `flutter test --update-goldens` e inspecione a renderização via `dart mcp-server` antes de concluir.
