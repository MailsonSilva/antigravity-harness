---
name: flutter-design-system
description: Arquitetura de Design System e theming em Flutter traduzindo _references/brand/DESIGN_SYSTEM.md para lib/core/theme/ (app_colors.dart, app_typography.dart, app_tokens.dart via ThemeExtension e app_theme.dart). NÃO use para estados de tela ou ergonomia de interação (use mobile-ux).
category: UI/UX & Design System
---

# Skill: Flutter Design System & Theming Tipado

## 1. Quando Acionar Esta Skill
- Ao iniciar a camada visual de um projeto traduzindo `_references/brand/DESIGN_SYSTEM.md` para `lib/core/theme/`.
- Ao configurar Light/Dark `ThemeData`, `ColorScheme`, `TextTheme` e tokens customizados via `ThemeExtension<AppTokens>`.
- Ao criar ou atualizar temas globais de `ElevatedButton`, `InputDecoration`, `Card`, `AppBar` e `NavigationBar`.
- NÃO acione quando: precisar definir estados Loading/Empty/Error/Success, teclados numéricos, alvos 48dp ou comportamento de scroll (use **`mobile-ux`**).

## 2. Arquitetura e Diretrizes Técnicas
1. **Fonte Única de Verdade:** leia `_references/brand/DESIGN_SYSTEM.md` antes de escrever código de tema ou UI.
2. **Estrutura Obrigatória em `lib/core/theme/`:**
   - `app_colors.dart`: tokens semânticos explícitos para Light e Dark mode (`primary`, `onPrimary`, `secondary`, `background`, `surface`, `surfaceVariant`, `textPrimary`, `textSecondary`, `border`, `success`, `warning`, `error`).
   - `app_typography.dart`: `TextTheme` completo (`displayLarge`, `headlineMedium`, `titleLarge`, `bodyLarge`, `bodyMedium`, `labelLarge`) usando as fontes e métricas do `DESIGN_SYSTEM.md`.
   - `app_tokens.dart`: `ThemeExtension<AppTokens>` para espaçamentos (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`), `borderRadius` (`sm`, `md`, `lg`, `full`), cores semânticas extras (`success`, `warning`, `border`, `surfaceVariant`) e sombras, exposto via getter `BuildContext.tokens`.
   - `app_theme.dart`: `ThemeData` Light e Dark centralizando `ColorScheme`, `TextTheme`, `extensions: [AppTokens.light / .dark]`, `ElevatedButtonThemeData`, `InputDecorationTheme`, `CardThemeData` e `AppBarTheme`.
3. **Consumo em `lib/features/`:** widgets consomem apenas `Theme.of(context)` (`colorScheme`, `textTheme`) e `context.tokens`.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// lib/core/theme/app_tokens.dart
import 'package:flutter/material.dart';

class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.border,
    required this.success,
    required this.warning,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final Color border;
  final Color success;
  final Color warning;

  static const light = AppTokens(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    radiusSm: 6,
    radiusMd: 12,
    radiusLg: 16,
    border: Color(0xFFE2E8F0),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
  );

  static const dark = AppTokens(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    radiusSm: 6,
    radiusMd: 12,
    radiusLg: 16,
    border: Color(0xFF232F48),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
  );

  @override
  AppTokens copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    Color? border,
    Color? success,
    Color? warning,
  }) {
    return AppTokens(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppTokens lerp(covariant ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      radiusSm: radiusSm,
      radiusMd: radiusMd,
      radiusLg: radiusLg,
      border: Color.lerp(border, other.border, t) ?? border,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
    );
  }
}

extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}
```

## 4. Antipadrões Proibidos
- ❌ Usar `Color(0x...)` ou `Colors.*` (exceto `Colors.transparent`) fora de `lib/core/theme/`.
- ❌ Definir `TextStyle(fontSize: ..., fontFamily: ...)` manualmente em widgets de `lib/features/` em vez de usar `Theme.of(context).textTheme`.
- ❌ Hardcodar `EdgeInsets.all(16)` ou `BorderRadius.circular(12)` repetidamente sem usar `context.tokens`.
