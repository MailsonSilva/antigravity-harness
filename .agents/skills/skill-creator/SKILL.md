---
name: skill-creator
description: "Criação, auditoria e otimização de novas skills para o Antigravity Harness. Use quando o usuário pedir para criar, formalizar ou refatorar uma habilidade técnica, workflow de engenharia ou diretriz de arquitetura."
category: "Meta-Engenharia & Scaffolding"
---

# Skill: Canonical Skill Creator & Scaffolding

## 1. Quando Acionar Esta Skill
- Sempre que uma nova tecnologia, biblioteca ou regra de negócio precisar ser padronizada no repositório.
- Quando o usuário solicitar explicitamente: "crie uma skill para X", "adicione suporte a Y".
- Durante o ciclo `harness-evolver` para registrar aprendizados obtidos após resolução de bugs complexos.

## 2. Princípios de Redação Canônica (Padrão Anthropic / Google Harness²)
1. **Critérios Estritos de Ativação (Triggering)**:
   - A descrição no frontmatter YAML deve declarar explicitamente **O QUE** a skill faz e **QUANDO** deve ser acionada, além de quando **NÃO** deve ser usada, prevenindo falsos positivos (*over-triggering*).
2. **Densa e Autocontida**:
   - Uma skill não deve se resumir a conselhos genéricos. Ela deve conter topologia de pastas, guardrails estritos, código canônico em Dart 3 / Flutter e lista de antipadrões proibidos.
3. **Persistência Imediata no Ecossistema**:
   - Toda skill criada deve ser salva em `.agents/skills/<folder>/SKILL.md` e registrada em `.agents/harness.yaml` sob `skills_registry`.

## 3. Template Canônico Obrigatório

```markdown
---
name: [identificador-kebab-case]
description: [Gatilhos específicos: O QUE faz e QUANDO usar com verbos de ação]
category: [Categoria Técnica]
---

# Skill: [Nome da Habilidade]

## 1. Quando Acionar Esta Skill
- [Gatilho 1]
- [Gatilho 2]
- NÃO acione quando: [Contra-indicação explícita]

## 2. Arquitetura e Diretrizes Técnicas
- [Regra de isolamento de camadas]
- [Regras de dependências e imports permitidos]

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// Exemplo real, completo e compilável sem ações

4. Antipadrões Proibidos
❌ [Antipadrão 1 e por que quebra o sistema]
❌ [Antipadrão 2]

## 4. Procedimento de Registro no Harness
Após gerar o arquivo `SKILL.md`:
1. Grave o arquivo em `.agents/skills/<id>/SKILL.md`.
2. Adicione a chave correspondente em `.agents/harness.yaml` em `skills_registry: <id>: ".agents/skills/<id>/SKILL.md"`.
3. Associe a skill aos agentes competentes (relação 1:N).