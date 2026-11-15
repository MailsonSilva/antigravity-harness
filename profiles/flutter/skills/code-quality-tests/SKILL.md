---
name: code-quality-tests
description: TDD estrito (Red-Green-Refactor), testes unitários de serviços de domínio, isolamento de SQLite em memória (sqflite_common_ffi) e contratos anti-regressão.
category: Qualidade & Testes
---

# Skill: Strict TDD & Isolamento de Testes em Flutter

## 1. Fluxo Obrigatório Red-Green-Refactor
1. **RED**: Crie o arquivo `*_test.dart` reproduzindo o bug ou validando o novo requisito. Rode `flutter test <caminho>` e confirme que FALHOU.
2. **GREEN**: Escreva o código de produção mínimo para satisfazer o teste.
3. **REFACTOR**: Elimine duplicações, rode `dart analyze` e confirme 0 warnings.

## 2. Regra Crítica para Testes com SQLite (`sqflite_common_ffi`)
Nunca compartilhe o mesmo arquivo `.db` físico entre testes paralelos (isso causa `database is locked`). Use banco em memória isolado por cada teste:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await criarSchemaDeTeste(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Deve calcular o mesmo preço na listagem e no detalhe do produto', () async {
    // Arrange, Act, Assert
  });
}
```
