---
name: flutter-use-http-package
description: Networking REST simples com package:http para chamadas pontuais (GET/POST sem interceptors). Para apps em produção com autenticação, refresh token ou retry, use flutter-networking-dio.
category: Dados & Rede
---

# Skill: Networking REST Simples (`package:http`)

## 1. Quando Acionar Esta Skill
- Apenas para chamadas HTTP simples e pontuais (ex.: consultar um endpoint público sem interceptors, refresh token ou retry complexo).
- Em scripts utilitários ou protótipos onde adicionar `dio` não se justifica.
- NÃO acione quando: o app estiver em produção com autenticação Bearer, refresh token, interceptors, cancelamento ou retry — use **`flutter-networking-dio`**.

## 2. Arquitetura e Diretrizes Técnicas
1. **Isolamento de Camada**: chamadas `http.Client` vivem apenas em services (`data/` ou `core/network/`), nunca em Widgets ou `AsyncNotifier`.
2. **Timeouts & Erros Tipados**: sempre aplique `.timeout(const Duration(seconds: 15))` e valide `statusCode` (200/201), lançando exceção tipada de falha em erro (nunca retorne `null` silencioso).
3. **Parsing em Isolate**: payloads JSON extensos devem usar `compute()` para não bloquear a UI thread.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<Item> parseItems(String body) => (jsonDecode(body) as List)
    .map((e) => Item.fromJson(e as Map<String, dynamic>))
    .toList();

class PublicCatalogApi {
  PublicCatalogApi(this._client, this._base);

  final http.Client _client;
  final Uri _base;

  Future<List<Item>> fetchAll() async {
    final res = await _client
        .get(_base.replace(path: '/items'))
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception('Falha HTTP ${res.statusCode}');
    }
    return compute(parseItems, res.body);
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Implementar refresh token manual e lógica complexa de retry sobre `package:http` quando `flutter-networking-dio` resolve nativamente.
- ❌ Deixar chamadas `http.get(...)` sem `.timeout(...)`.
- ❌ Hardcodar tokens no código em vez de usar `--dart-define-from-file` (`flutter-environments-security`).
