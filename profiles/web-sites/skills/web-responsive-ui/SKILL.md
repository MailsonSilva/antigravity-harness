---
name: web-responsive-ui
description: Construção de interfaces web responsivas, componentes com Tailwind CSS, padrões mobile-first, design tokens e acessibilidade (a11y).
---

# Skill: Interfaces Web Responsivas e Componentes Tailwind

Esta skill orienta a construção de componentes e layouts web responsivos, acessíveis e reutilizáveis utilizando Tailwind CSS e TypeScript.

## 1. Gatilho de Ativação
Acione quando:
- Construir ou adaptar componentes de interface web (botões, cards, modais, navegações).
- Ajustar layouts para diferentes breakpoints (mobile, tablet, desktop, ultra-wide).
- Implementar transições fluidas e acessibilidade de foco e teclado.

## 2. Princípios de Implementação
1. **Mobile-First por Padrão**:
   - Estilize primeiro para telas pequenas sem prefixos.
   - Aplique modificadores responsivos progressivamente: `sm:` (640px), `md:` (768px), `lg:` (1024px), `xl:` (1280px).
2. **Design Tokens & Variáveis**:
   - Utilize a paleta de cores e espaçamentos definidos em `tailwind.config` ou CSS variables (`globals.css`).
   - Evite valores arbitrários não justificados (ex: `w-[347px]`).
3. **Ergonomia e Alvos de Toque**:
   - Elementos clicáveis devem possuir no mínimo 44x44px de área de clique em dispositivos móveis.
   - Navegação mobile tipo off-canvas ou bottom-bar acessível com polegar.
4. **Acessibilidade (a11y)**:
   - Contraste de cores mínimo WCAG AA (4.5:1 para texto normal).
   - Anéis de foco visíveis (`focus-visible:ring-2`).
   - Respeito à preferência de movimento reduzido (`motion-reduce:...`).

## 3. Checklist de Aceitação
- [ ] Layout não quebra nem causa scroll horizontal em larguras entre 320px e 1920px.
- [ ] Menus e elementos interativos navegáveis 100% via teclado (`Tab`, `Enter`, `Escape`).
- [ ] Elementos interativos com estados visuais claros (`hover`, `active`, `focus-visible`, `disabled`).
- [ ] Ícones acessíveis com `aria-hidden="true"` ou texto alternativo via `sr-only`.
