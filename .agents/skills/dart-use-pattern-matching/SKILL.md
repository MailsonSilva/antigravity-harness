---
name: dart-use-pattern-matching
description: Uso avançado de Dart 3: Records, Sealed Classes, Switch Expressions exaustivas, Destructuring e If-Case para código seguro e conciso.
category: Engenharia Mobile
---

# Skill: Dart 3 Pattern Matching & Modern Syntax

## 1. Quando Usar
- Substituir hierarquias verbosas de `if/else` por `switch` expressions exaustivas sobre `sealed class`.
- Desestruturar JSONs ou tuplas retornadas de consultas combinadas usando `Records`.

```dart
Widget buildStatusBadge(StatusPedido status) {
  return switch (status) {
    PedidoRascunho() => const Chip(label: Text('Rascunho')),
    PedidoSincronizando(:final progresso) => CircularProgressIndicator(value: progresso),
    PedidoTransmitido(:final numeroErp) => Chip(label: Text('ERP #$numeroErp')),
    PedidoComErro(:final motivo) => Tooltip(message: motivo, child: const Icon(Icons.error)),
  };
}
```
