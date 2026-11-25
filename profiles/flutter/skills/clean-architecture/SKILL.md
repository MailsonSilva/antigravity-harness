---
name: clean-architecture
description: Estrutura de camadas Clean Architecture (Presentation, Domain, Data), inversão de dependência, pureza de domínio e tratamento funcional de erros com sealed classes em Flutter. NÃO use para convenções passo a passo de implementação Dart, Riverpod ou build_runner.
category: Arquitetura & Domínio
---

# Skill: Clean Architecture & Pureza de Domínio (Flutter / Dart 3)

## 1. Quando Acionar Esta Skill
- Ao criar uma nova feature e definir fronteiras entre `domain/`, `data/` e `presentation/`.
- Ao extrair regras de negócio ou cálculos comerciais espalhados em Widgets/Controllers para `DomainService`.
- Ao modelar contratos de repositório (`abstract interface class`) e retornos tipados (`sealed class Result<T>`).
- NÃO acione quando: a estrutura de camadas já estiver definida e a tarefa for apenas convenções de código Dart/Notifier (`flutter-apply-architecture-best-practices`) ou geração de código (`flutter-code-generation`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Topologia de Pastas por Feature (`lib/features/<feature_name>/`)**:
   - `domain/`: `entities/` (objetos puros), `repositories/` (contratos abstratos), `services/` (regras comerciais puras), `failures/` (falhas tipadas).
   - `data/`: `datasources/` (Local SQLite e Remote Dio/Supabase), `models/` (DTOs com mapeamento `toEntity()`), `repositories/` (implementações dos contratos de `domain/`).
   - `presentation/`: `controllers/` (State Notifiers), `pages/` (telas), `widgets/` (componentes isolados).
2. **Regra da Dependência (Inversão Estrita)**:
   - Direção única: `presentation` → `domain` ← `data`.
   - `domain/` é 100% Dart puro: **proibido** importar `package:flutter/material.dart`, `sqflite`, `dio`, `http` ou `supabase_flutter`.
3. **Separação Model vs. Entity**:
   - `Model`/`DTO` conhece JSON/colunas de banco e converte para `Entity` via `toEntity()`.
   - `Entity` usa nomenclatura semântica de negócio e valida invariantes.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// domain/failures/result.dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message, {this.code = 'DOMAIN_ERROR'});
  final String message;
  final String code;
}

// domain/repositories/pedido_repository.dart
abstract interface class PedidoRepository {
  Future<Result<double>> calcularTotalPedido(String pedidoId);
}

// domain/services/preco_calculator_service.dart
class PrecoCalculatorService {
  const PrecoCalculatorService();

  double calcularPrecoFinal({
    required double precoTabela,
    double fatorPagamento = 1.0,
    double percentualDesconto = 0.0,
  }) {
    final fator = fatorPagamento > 0 ? fatorPagamento : 1.0;
    final liquido = (precoTabela * fator) * (1 - (percentualDesconto / 100));
    return double.parse(liquido.toStringAsFixed(2));
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Importar `material.dart`, `sqflite` ou `dio` dentro de qualquer arquivo em `domain/`.
- ❌ Retornar `Map<String, dynamic>` cru do repositório para a camada `presentation/`.
- ❌ Calcular preços, impostos ou descontos dentro de `Widget.build()` ou queries SQL duplicadas.
- ❌ Silenciar exceções com `catch (_) { return []; }` sem propagar `Failure`.
