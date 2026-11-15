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
- Se houver lacunas ou regras de negócio implícitas, formular no máximo 3 perguntas diretas.
- Propor escolhas padrão para UX, modelos de erro e offline-first caso o usuário não especifique.

### Passo 3: Geração da `_specs/SPEC.md`
Escrever a especificação seguindo rigorosamente a estrutura abaixo:

```markdown
# SPEC: [Nome da Funcionalidade]

## 1. Visão Geral e Contexto de Negócio
- Descrição concisa do objetivo.
- Perfis de usuário impactados.

## 2. Contratos de Dados & Entidades
- Estrutura das entidades (tipos, campos obrigatórios, nulos).
- Migrações necessárias (se SQLite/Postgres) ou esquemas DTO.

## 3. Arquitetura e Camadas
- **Domain**: Entidades e interfaces de repositórios.
- **Data**: Implementações de data sources e mappers.
- **Presentation / UI**: Componentes, telas e gerenciamento de estado.

## 4. Matriz de Tarefas Atômicas (Para o Orquestrador Argon)
- [ ] `TASK-01`: [Camada/Componente] - Descrição e arquivos envolvidos.
- [ ] `TASK-02`: [Camada/Componente] - Descrição e arquivos envolvidos.
- [ ] `TASK-03`: [Testes] - Testes unitários/widget para a feature.

## 5. Critérios de Aceitação (Gherkin / Checklist)
- Cenários principais de sucesso.
- Cenários de borda (offline, erro de rede, dados vazios).

## 6. Comandos do Gate de Verificação
- Comando de lint: `[flutter analyze | npm run lint]`
- Comando de testes: `[flutter test <arquivo> | npm test]`
- Comando de compilação: `[flutter build ... | npm run build]`
```

### Passo 4: Stop Gate (Aprovação Humana)
Apresentar um resumo executivo da `SPEC.md` ao usuário e aguardar a validação explícita antes de invocar o workflow de orquestração (`orchestrate.md`).
