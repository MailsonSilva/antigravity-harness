# Diretrizes Específicas: Web & Landing Pages (Next.js / React / Tailwind)

---

## 1. Arquitetura e Estrutura de Pastas (App Router)
Adote Next.js App Router focado em páginas de alta conversão e aplicações web modernas:

```text
src/ (ou raiz)
├── app/                   # Rotas, layouts, metadata, sitemap.ts e robots.ts
│   ├── layout.tsx         # Layout raiz com fontes (next/font) e scripts de analytics
│   ├── page.tsx           # Landing page principal
│   └── ...                # Páginas de obrigado, termos, blog ou dashboard
├── components/            # UI Components desacoplados
│   ├── ui/                # Botões, inputs, cards, dialogs (Tailwind)
│   └── sections/          # Hero, Features, Pricing, Testimonials, FAQ, Footer
├── lib/                   # Utilitários, formatação, analytics e clientes
└── styles/                # Configurações globais e diretivas do Tailwind
```

### Regras de Renderização
- **Server Components por Padrão**: Toda seção de conteúdo estático ou server-driven deve ser Server Component para máxima velocidade de carregamento e indexação imediata.
- **Client Components Restritos**: Use `"use client"` estritamente em componentes interativos (formulários, carrosséis, accordions interativos).
- **Sem Segredos no Cliente**: Variáveis sensíveis ficam no servidor; variáveis expostas ao browser usam obrigatoriamente o prefixo `NEXT_PUBLIC_`.

---

## 2. Princípios de Landing Pages de Alta Conversão
- **Hero Section Cirúrgica**: Proposta de valor clara (H1), subtítulo explicativo, CTA de alto contraste (área de clique generosa) e prova social imediata (*above the fold*).
- **Blocos Essenciais**:
  1. *Hero* com benefício direto + CTA primária.
  2. *Social Proof* (logos, depoimentos reais, avaliações com estrelas).
  3. *Features / Como Funciona* (3 a 4 pilares visuais com ícones ou capturas).
  4. *Planos e Preços* (tabela clara destacando o plano mais popular).
  5. *FAQ em Accordion* (quebra de objeções frequentes).
  6. *CTA Final* (reforço da chamada para ação antes do rodapé).
- **Formulários e Conversão**:
  - Feedback visual imediato durante o envio (loading state no botão).
  - Validação estrita de dados no cliente e no servidor (ex: Zod).
  - Redirecionamento amigável para página de agradecimento ou disparo de evento de conversão (Meta Pixel / Google Tag).

---

## 3. Performance & Core Web Vitals
- **Metas Mobile (p75)**: `LCP` ≤ 2.5s | `INP` ≤ 200ms | `CLS` ≤ 0.1.
- **Imagens**: Sempre utilizar `next/image` com dimensões explícitas; use `priority` estritamente na imagem principal da *Hero Section*.
- **Fontes**: Carregadas via `next/font/google` com `display: swap` para eliminar layout shifts.
- **Tailwind Responsivo**: Construção Mobile-First obrigatória (`sm:`, `md:`, `lg:`, `xl:`).

---

## 4. SEO Técnico e Rastreabilidade
- **Metadados Obrigatórios**: `title`, `description`, `canonical`, `openGraph` e `twitter` configurados no `metadata` de cada página.
- **Arquivos Estruturais**: Manter `sitemap.ts` e `robots.ts` gerados dinamicamente no App Router.
- **Marcação Semântica**: Um único `h1` por página, hierarquia sequencial de headings (`h2`, `h3`) e dados estruturados em JSON-LD (`Organization`, `Product` ou `FAQPage`).

---

## 5. Loop Obrigatório de Verificação (Web Gate)
Antes de submeter ou concluir qualquer tarefa:
```bash
# 1. Checagem estática de tipos e linter
npm run lint

# 2. Build de produção (deve compilar com sucesso sem warnings de tipagem)
npm run build
```
Proibido concluir tarefas se houver erros de compilação ou falhas de TypeScript.
