---
name: supabase-flutter
description: Arquitetura segura com Supabase em Flutter: Auth, políticas Row Level Security (RLS), sincronização offline/online, RPCs e Storage.
category: Backend & Cloud
---

# Skill: Supabase Fullstack & RLS Architecture

## 1. Guardrails Obrigatórios
1. **RLS Sempre Ativo**: Nenhuma tabela no schema `public` pode existir sem `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`.
2. **Operações Atômicas via RPC**: Para operações financeiras ou fechamento de pedidos que alteram múltiplas tabelas, crie uma PostgreSQL Function (`rpc`) transacional em vez de fazer várias requisições seguidas pelo cliente mobile.
3. **Sincronização Incremental**: Use colunas `updated_at` indexadas para puxar apenas os registros modificados desde o último timestamp de sincronização (`gt('updated_at', lastSyncIso)`).
