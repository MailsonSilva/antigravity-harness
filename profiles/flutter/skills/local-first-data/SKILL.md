---
name: local-first-data
description: Engenharia Offline-First com SQLite em Flutter: indexação composta, buscas paginadas sem travamento de UI, debounce e sincronização em lote (Batch).
category: Dados & Offline
---

# Skill: Local-First SQLite & High-Performance Sync

## 1. Quando Acionar Esta Skill
Acione ao criar ou otimizar tabelas SQLite locais, implementar barras de pesquisa em catálogos grandes (> 5.000 itens), processar cargas offline (arquivos FTP/ZIP/JSON) ou resolver lentidão de leitura.

## 2. Regras de Ouro de Performance SQLite
1. **Zero Full Table Scan**: Toda coluna utilizada em `WHERE`, `JOIN` ou `ORDER BY` deve ter índice criado na migração (`CREATE INDEX IF NOT EXISTS`).
2. **Paginação Obrigatória**: Nunca carregue milhares de linhas na memória RAM do aparelho. Use sempre `LIMIT :limit OFFSET :offset` (padrão: 30 a 50 itens por página).
3. **Projeção Enxuta**: Nas listagens e buscas, selecione apenas as colunas visíveis no card (`SELECT id, nome, preco, estoque`). Deixe campos pesados (observações longas, metadados fiscais) para a query de detalhes do item.
4. **Inserção em Lote (Batch Transaction)**: Ao sincronizar dados recebidos do servidor, nunca execute `await db.insert()` dentro de um `for` simples. Use `db.transaction` com `batch.insert` e `batch.commit(noResult: true)`.

## 3. Padrão Canônico de Índices e Query Paginada
```dart
// 1. Criação de Índices na abertura/migração do banco
Future<void> ensurePerformanceIndexes(Database db) async {
  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_produtos_busca 
    ON cadpro00 (pro00_descri, pro00_codbar, pro00_codfab);
  ''');
  await db.execute('''
    CREATE INDEX IF NOT EXISTS idx_estoque_filial_prod 
    ON estpro00 (pro00_codfil, pro00_codpro);
  ''');
}

// 2. Busca Paginada Rápida com Filtro Parametrizado
Future<List<Map<String, Object?>>> buscarProdutosPaginado({
  required Database db,
  required int codFilial,
  required String termo,
  int limit = 30,
  int offset = 0,
}) async {
  final filtro = '%${termo.trim()}%';
  return db.rawQuery('''
    SELECT 
      p.pro00_codigo,
      p.pro00_descri,
      p.pro00_codbar,
      p.pro00_mulemb,
      COALESCE(e.pro00_qtdest - e.pro00_qtdpen, 0) AS estoque_disponivel
    FROM cadpro00 p
    LEFT JOIN estpro00 e 
      ON e.pro00_codpro = p.pro00_codigo AND e.pro00_codfil = ?
    WHERE p.pro00_descri LIKE ? 
       OR p.pro00_codbar LIKE ? 
       OR CAST(p.pro00_codigo AS TEXT) = ?
    ORDER BY p.pro00_descri ASC
    LIMIT ? OFFSET ?
  ''', [codFilial, filtro, filtro, termo.trim(), limit, offset]);
}
```

## 4. Debounce na Camada de Apresentação
Nunca dispare query no SQLite a cada tecla pressionada (`onChanged`). Aplique um Debouncer de 300ms a 350ms e cancele requisições obsoletas.
