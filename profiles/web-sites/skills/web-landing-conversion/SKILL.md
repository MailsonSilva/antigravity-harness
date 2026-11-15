---
name: web-landing-conversion
description: Padrões de arquitetura de landing pages de alta conversão, copywriting persuasivo, formulários com feedback imediato, analytics e quebra de objeções.
---

# Skill: Landing Pages de Alta Conversão

Esta skill orienta a criação de landing pages focadas em conversão, retenção e experiência de usuário fluida em Next.js e React.

## 1. Gatilho de Ativação
Acione quando:
- Criar ou refatorar landing pages, squeeze pages ou páginas de vendas/captura.
- Implementar formulários de lead, checkout ou contato.
- Integrar tracking de conversão (Meta Pixel, Google Tag Manager, analytics).

## 2. Estrutura Canônica de Conversão
1. **Hero Section (Primeira Dobra)**:
   - Título magnético com benefício primário evidente (`h1`).
   - Subtítulo clarificador que elimina a maior dúvida do usuário.
   - Botão de CTA primário em destaque de cor contrastante.
   - Prova social imediata (ex: "Mais de 10.000 usuários ativos", estrelas de review).
2. **Problema vs. Solução**:
   - Descrição visual da dor antes e do alívio trazido pelo produto.
3. **Features & Benefícios**:
   - 3 a 4 cartões objetivos com ícones e explicações curtas.
4. **Depoimentos / Prova Social**:
   - Depoimentos reais com foto/avatar, nome e cargo/empresa.
5. **Tabela de Preços / Planos**:
   - Destaque claro para o plano "Mais Popular" ou "Recomendado".
   - Detalhamento de benefícios inclusos com ícones de check.
6. **FAQ (Perguntas Frequentes)**:
   - Accordion interativo antecipando as 5 objeções de compra mais comuns.
7. **CTA Final**:
   - Reforço de garantia (ex: "7 dias sem compromisso") e CTA de fechamento.

## 3. Padrão de Formulário e Feedback
- Validação com Zod e React Hook Form.
- Feedback imediato de carregamento no botão (`disabled` + spinner).
- Mensagens de erro contextualizadas no campo correspondente (não em alerta genérico).
- Evento de analytics disparado no sucesso antes do redirect.

## 4. Checklist de Aceitação
- [ ] CTA visível e acessível na primeira dobra em mobile e desktop.
- [ ] Formulário com estados de submissão claros (idle, loading, success, error).
- [ ] Pixel/Tag com disparos de eventos (`Lead`, `InitiateCheckout`, `Contact`).
- [ ] Microcópia transparente de política de privacidade e termos.
