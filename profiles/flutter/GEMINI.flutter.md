# Diretrizes Específicas: Flutter (Mobile & SaaS Offline-First)

---

## 1. Arquitetura de Camadas (Clean / MVVM)
Adote estrutura modular estrita por feature:

```text
lib/
├── core/                  # Serviços globais, DB local, tema e utilitários
│   ├── database/          # SQLite (migrations, helpers, DAOs)
│   ├── network/           # Clientes HTTP / Supabase SDK
│   └── theme/             # Design Tokens, tipografia e estilos
├── features/
│   └── [feature_name]/
│       ├── data/          # Models, DTOs, DataSources e Repositórios concretos
│       ├── domain/        # Entidades puras e Interfaces de repositório
│       └── presentation/  # Telas, Widgets e State Notifiers
└── main.dart
```

### Regras de Dependência
- **Domain**: Dart puro, sem imports de Flutter, widgets ou pacotes externos de UI.
- **Presentation**: Depende exclusivamente do Domain e de seus próprios Notifiers/Controllers. Nunca chama SQLite ou APIs diretamente do Widget.
- **Data**: Implementa as interfaces do Domain, tratando mapeamentos, erros e cache local.

---

## 2. Padrão dos 4 Estados de UI
Todo ecrã ou componente que consome dados assíncronos deve tratar explicitamente:
1. **Loading**: Indicador de progresso ou shimmer skeleton contextual.
2. **Empty**: Mensagem amigável + Call to Action claro para inclusão do primeiro item.
3. **Error**: Mensagem clara em pt-BR + botão obrigatório de "Tentar Novamente".
4. **Success**: Renderização limpa dos dados, com paginação ou scroll infinito sob demanda.

---

## 3. Persistência Offline-First (SQLite Local)
- **Migrations Versionadas**: Nunca altere a estrutura do banco em produção diretamente; use scripts de migração sequenciais no `onUpgrade`.
- **Índices Compostos**: Adicione índices para colunas usadas frequentemente em filtros (`WHERE`), ordenações (`ORDER BY`) ou chaves estrangeiras.
- **Operações em Lote**: Mutações em massa devem rodar dentro de transações com `batch.commit(noResult: true)`.
- **Testes em Memória**: Repositórios e DAOs locais devem ser testados via `sqflite_common_ffi` com `databaseFactoryFfi` (sem necessidade de emulador físico).

---

## 4. Ergonomia e UI Mobile
- **Área Mínima de Toque**: Todo elemento interativo deve ter no mínimo **48x48 dp**.
- **Performance**: Use construtores `const` sempre que o widget não contiver estado mutável.
- **Design Tokens**: Cores, espaçamentos e fontes devem ser consumidos de `core/theme/` (proibido valores mágicos de cores na UI).

---

## 5. Loop Obrigatório de Verificação (Flutter Gate)
Antes de finalizar qualquer tarefa ou PR:
```powershell
# 1. Formatação de código
dart format .

# 2. Análise estática obrigatória (deve retornar 0 avisos)
flutter analyze

# 3. Execução de testes automatizados
flutter test
```
Proibido concluir tarefas se `flutter analyze` reportar avisos ou se qualquer teste falhar.
