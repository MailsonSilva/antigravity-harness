# Workflow: Planejamento Arquitetural (Carbon / SPEC)

**Modelo recomendado**: Gemini 4 Carbon (Alta capacidade de raciocínio e síntese).
**Gatilho**: Início de nova funcionalidade, refatoração de grande porte ou definição de módulo.
**Saída Obrigatória**: Arquivo `_specs/SPEC.md` validado e aprovado antes de qualquer escrita de código.

---

## 1. Objetivo da Fase
Mapear integralmente os requisitos de negócio, contratos de dados, dependências e critérios de aceitação, eliminando ambiguidades sem consumir tokens em implementações precipitadas.

---

## 2. Etapas de Execução

### Passo 1: Inspeção Prévia do Contexto
- Ler arquivos de configuração do projeto (`pubspec.yaml` ou `package.json`).
- Inspecionar a estrutura existente de diretórios e contratos já estabelecidos.
- Identificar dependências de persistência (ex: SQLite local, Supabase, API REST).

### Passo 2: Entrevista e Alinhamento Técnico (Cirúrgico)
- Formular no máximo **3 a 5 perguntas diretas** sobre lacunas reais (transições de estado, falhas offline/rede, contratos de erro e limites de escopo).
- Propor escolhas padrão para UX, modelos de erro e offline-first caso o usuário não especifique.

### Passo 3: Geração da `_specs/SPEC.md` (Micro-Spec)
Escrever uma **Micro-Spec** enxuta (uma fatia vertical por vez, legível em ~2 minutos) seguindo rigorosamente a estrutura abaixo:

```markdown
# SPEC: [Nome da Funcionalidade]

## 1. Visão Geral e Contexto de Negócio
- Descrição concisa do objetivo (fatia vertical única).
- Perfis de usuário impactados.

## 2. Contratos de Dados & Entidades
- Estrutura das entidades (tipos, campos obrigatórios, nulos).
- Migrações necessárias (se SQLite/Postgres) ou esquemas DTO.

## 3. Arquitetura e Camadas
- **Domain**: Entidades e interfaces de repositórios.
- **Data**: Implementações de data sources e mappers.
- **Presentation / UI**: Componentes, telas, gerenciamento de estado e 4 estados (`Loading`, `Empty`, `Error`, `Success`).

## 4. Guardrails Negativos (Fora de Escopo / Não Tocar)
- Arquivos, módulos e contratos existentes que NÃO devem ser alterados pelos subagentes.

## 5. Matriz de Tarefas Atômicas (TDD First → Para o Orquestrador Argon)
- [ ] `TASK-01`: [Base/Contratos] - Entidades, interfaces e schemas.
- [ ] `TASK-02`: [Fase RED] - Testes unitários/widget mapeados 1:1 dos critérios da Seção 6.
- [ ] `TASK-03`: [Fase GREEN] - Implementação mínima (Data/Presentation) para passar nos testes da `TASK-02`.

## 6. Critérios de Aceitação (Dado / Quando / Então → Teste RED 1:1)
- Cenários principais de sucesso → `[arquivo_test.dart :: caso]`
- Cenários de borda (offline, erro de rede, dados vazios) → `[arquivo_test.dart :: caso]`

## 7. Comandos do Gate de Verificação
- Comando de lint: `[dart analyze | npm run lint]`
- Comando de testes: `[flutter test <arquivo> | npm test]`
- Comando de compilação: `[flutter build ... | npm run build]`
```

### Passo 4: Stop Gate (Aprovação Humana)
Apresentar um resumo executivo da `SPEC.md` ao usuário e aguardar a validação explícita antes de invocar o workflow de orquestração (`orchestrate.md`).
