---
name: clean-architecture
description: Arquitetura Limpa em Flutter com separação estrita Presentation, Domain e Data, Domain Services puros e tratamento funcional de erros com sealed classes.
category: Engenharia de Software
---

# Skill: Clean Architecture & Domain Purity (Flutter/Dart 3)

## 1. Quando Acionar Esta Skill
Acione sempre que criar uma nova feature, refatorar regras de negócio espalhadas em Widgets/Controllers ou corrigir divergências de cálculo comercial entre telas (ex: pesquisa vs pedido).

## 2. Topologia de Pastas por Feature
```text
lib/features/<feature_name>/
├── domain/
│   ├── entities/          # Objetos imutáveis de negócio (100% Dart puro)
│   ├── repositories/      # Interfaces abstratas (contratos)
│   ├── services/          # Regras comerciais complexas (ex: PrecoDomainService)
│   └── failures/          # Sealed classes de falhas de domínio
├── data/
│   ├── datasources/       # LocalDataSource (SQLite) e RemoteDataSource (REST/Supabase)
│   ├── models/            # DTOs com fromJson/toJson e fromMap/toMap + toEntity()
│   └── repositories/      # Implementação concreta dos contratos de domain
└── presentation/
    ├── controllers/       # Notifiers / AsyncNotifiers (Riverpod)
    ├── pages/             # Scaffolds de tela
    └── widgets/           # Componentes visuais desacoplados e const
```

## 3. Regras Inegociáveis (Guardrails)
1. **Regra da Dependência**: `presentation` -> `domain` <- `data`. O diretório `domain` NUNCA importa pacotes de UI (`package:flutter/material.dart`) nem pacotes de banco/rede (`sqflite`, `dio`, `supabase_flutter`).
2. **Centralização de Cálculos**: É proibido calcular preços, descontos, impostos ou saldos dentro de `Widget.build()` ou dentro de queries SQL duplicadas. Crie um `DomainService` testável.
3. **Model vs Entity**: `Model` conhece JSON e colunas do SQLite (`pro00_codigo`). `Entity` usa nomes semânticos do domínio (`idProduto`, `precoBase`) e valida invariantes no construtor.

## 4. Padrão de Código Canônico (Dart 3 Sealed Result & Domain Service)
```dart
// domain/failures/result.dart
sealed class Result<T> {
  const Result();
}
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}
final class Failure<T> extends Result<T> {
  final String message;
  final String code;
  const Failure(this.message, {this.code = 'DOMAIN_ERROR'});
}

// domain/services/preco_calculator_service.dart
class PrecoCalculatorService {
  const PrecoCalculatorService();

  double calcularPrecoFinal({
    required double precoTabela,
    required double fatorPlanoPagamento,
    required double multiplicadorEmbalagem,
    double percentualDesconto = 0,
  }) {
    final fator = fatorPlanoPagamento > 0 ? fatorPlanoPagamento : 1.0;
    final mult = multiplicadorEmbalagem > 0 ? multiplicadorEmbalagem : 1.0;
    final bruto = precoTabela * fator * mult;
    final comDesconto = bruto * (1 - (percentualDesconto / 100));
    return double.parse(comDesconto.toStringAsFixed(2));
  }
}
```

## 5. Antipadrões Proibidos
- ❌ Chamar `DatabaseHelper.instance.query(...)` diretamente de dentro de um `StatefulWidget`.
- ❌ Retornar `Map<String, dynamic>` cru do repositório para a camada de UI.
- ❌ Silenciar exceções com `catch (e) { return []; }` sem propagar `Failure` para o estado da tela.
