---
name: flutter-golden-tests
description: Testes visuais de snapshot (Golden Tests) com alchemist ou golden_toolkit para validar widgets e telas contra _references/screens/ e evitar regressões visuais. Use ao validar fidelidade visual, design system ou múltiplos temas/tamanhos.
category: Qualidade & Testes
---

# Skill: Golden Tests & Regressão Visual (Alchemist / Golden Toolkit)

## 1. Quando Acionar Esta Skill
- Ao implementar componentes de UI do Design System ou telas baseadas em protótipos de `_references/screens/`.
- Ao detectar regressões visuais recorrentes (overflow, contraste, espaçamento, tema claro/escuro) em PRs.
- Para validar múltiplos cenários visuais (tamanhos de tela, `textScaler` e temas) de forma determinística.
- NÃO acione quando: precisar testar apenas comportamento lógico/interação sem snapshot de pixel (`flutter-add-widget-test`) ou fluxo completo em device real (`flutter-add-integration-test`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Stack Recomendada**: utilize `alchemist` (preferencial por separar goldens de plataforma vs. CI) ou `golden_toolkit`.
2. **Determinismo de Fontes e Ambiente**:
   - Configure `test/flutter_test_config.dart` chamando `loadAppFonts()` / `AlchemistConfig` antes dos testes para não renderizar retângulos ("Ahem").
   - Marque testes com `tags: ['golden']` no `dart_test.yaml` para isolar execuções visuais quando o host variar de SO.
3. **Cenários Obrigatórios vs. `_references/screens/`**:
   - Compare layout, tipografia e tokens de `_references/screens/` cobrindo estados `Loading`, `Empty`, `Error` e `Success` além de variações `Light`/`Dark` e dispositivo compacto (`360x640`) vs. padrão (`412x915`).
4. **Comandos Canônicos**:
   - Gerar/atualizar baselines após mudança visual intencional: `flutter test --update-goldens --tags=golden`
   - Validar regressão no dia a dia/CI: `flutter test --tags=golden`

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// test/features/catalog/presentation/product_card_golden_test.dart
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  goldenTest(
    'ProductCard renderiza estados padrão e promocional sem overflow',
    fileName: 'product_card',
    tags: const ['golden'],
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 360),
      children: [
        GoldenTestScenario(
          name: 'padrão',
          child: const Material(
            child: ProductCard(title: 'Café Especial 250g', price: 'R\$ 34,90'),
          ),
        ),
        GoldenTestScenario(
          name: 'título longo',
          child: const Material(
            child: ProductCard(
              title: 'Nome de produto muito longo para validar elipse e quebra',
              price: 'R\$ 129,90',
            ),
          ),
        ),
      ],
    ),
  );
}
```

## 4. Antipadrões Proibidos
- ❌ Rodar `--update-goldens` automaticamente para "fazer o teste passar" sem inspecionar o diff da imagem gerada.
- ❌ Testar goldens sem carregar as fontes do projeto (gerando blocos pretos/Ahem).
- ❌ Incluir timestamps dinâmicos (`DateTime.now()`) ou animações infinitas não controladas nos snapshots.
