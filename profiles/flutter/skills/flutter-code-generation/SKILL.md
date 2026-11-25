---
name: flutter-code-generation
description: Geração de código com build_runner, freezed, json_serializable e riverpod_generator em projetos Flutter/Dart 3. Use ao criar DTOs imutáveis, unions ou providers com @riverpod e ao manter arquivos .g.dart/.freezed.dart.
category: Engenharia de Software
---

# Skill: Geração de Código (`build_runner`, `freezed`, `riverpod_generator`)

## 1. Quando Acionar Esta Skill
- Ao criar modelos/DTOs com `freezed` e `json_serializable` (`fromJson`/`toJson`, `copyWith`, igualdade estrutural).
- Ao declarar providers anotados com `@riverpod` via `riverpod_generator`.
- Ao corrigir conflitos ou dessincronia em arquivos `.g.dart` e `.freezed.dart`.
- NÃO acione quando: a entidade de domínio pura não precisar de serialização/boilerplate (prefira Dart 3 puro com `sealed class` e `final class` em `domain/`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Diretivas `part` Obrigatórias**:
   - Arquivo com apenas `json_serializable` ou `@riverpod`: declare `part '<arquivo>.g.dart';`.
   - Arquivo com `freezed` + `json_serializable`: declare **ambos** `part '<arquivo>.freezed.dart';` e `part '<arquivo>.g.dart';`.
2. **Quando Executar o `build_runner`**:
   - Sempre que alterar anotações `@freezed`, `@JsonSerializable`, `@JsonKey`, `@riverpod` ou adicionar um novo arquivo com `part`.
   - Comando padrão: `dart run build_runner build --delete-conflicting-outputs`
   - Durante desenvolvimento iterativo contínuo: `dart run build_runner watch --delete-conflicting-outputs`
3. **Regras de Organização & Git**:
   - Mantenha arquivos `.g.dart` e `.freezed.dart` ao lado do arquivo fonte e **versionados no Git** para que `dart analyze` e `flutter test` rodem em CI sem etapa obrigatória prévia (ou valide sincronia no CI).
   - **Nunca** edite manualmente linhas dentro de `.g.dart` ou `.freezed.dart`.
   - Exclua `**/*.g.dart` e `**/*.freezed.dart` de regras estritas de cobertura se configurado no `analysis_options.yaml` (`analyzer.exclude` apenas se necessário para lints de estilo gerados).

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// data/models/product_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
abstract class ProductDto with _$ProductDto {
  const ProductDto._();

  const factory ProductDto({
    required String id,
    @JsonKey(name: 'display_name') required String displayName,
    @Default(0.0) double price,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Product toEntity() => Product(id: id, name: displayName, price: price);
}
```

## 4. Antipadrões Proibidos
- ❌ Editar manualmente `.g.dart` ou `.freezed.dart` para contornar erros de compilação.
- ❌ Esquecer a diretiva `part` ou trocar a ordem do nome do arquivo no `part`.
- ❌ Concluir uma tarefa de código após editar modelos anotados sem rodar `dart run build_runner build --delete-conflicting-outputs` e `dart analyze`.
