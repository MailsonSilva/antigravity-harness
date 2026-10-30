# Diretrizes Técnicas para Desenvolvimento Web (React / Next.js)

Este guia estabelece os padrões de arquitetura, renderização, performance, SEO e segurança para as aplicações em `apps/web/` e `apps/landing/`.

---

## 1. Arquitetura e Separação de Camadas
Adotamos o App Router do Next.js com Server Components como padrão:

```text
apps/web/
├── app/                   # Rotas, layouts e metadata por segmento
├── components/            # Apresentação reutilizável (UI pura)
├── features/              # Módulos funcionais isolados
│   └── [feature_name]/
│       ├── components/    # Componentes específicos da feature
│       ├── data/          # Server actions, route handlers e clientes
│       └── domain/        # Tipos, regras e validações puras
├── lib/                   # Utilitários, clientes HTTP e configuração
└── styles/                # Tokens visuais e estilos globais
```

### Regras de Dependência:
- **Server Components por padrão**: use `"use client"` apenas quando houver estado local, efeitos ou APIs exclusivas do browser.
- A camada de **apresentação** (`components/`) não acessa banco de dados, SDKs ou `fetch` direto; dados entram por props ou server actions em `features/*/data/`.
- O **domínio** (`domain/`) é TypeScript puro: sem imports de React, Next.js ou SDKs externos.
- Segredos nunca no bundle do cliente: apenas variáveis de servidor. `NEXT_PUBLIC_*` é reservado a valores públicos.

---

## 2. Performance e Core Web Vitals
1. **Metas de qualidade (p75 mobile)**:
   - `LCP` ≤ 2,5 s · `INP` ≤ 200 ms · `CLS` ≤ 0,1.
2. **Imagens**: use `next/image` com `width`/`height` explícitos e formatos modernos; `priority` apenas na imagem hero.
3. **Fontes**: carregue via `next/font` com `display: swap`; sem requisições bloqueantes de terceiros.
4. **JavaScript**: orçamento de até 170 KB gzip no primeiro carregamento; use `dynamic import` para componentes pesados e bibliotecas de gráficos/editores.
5. **Dados**: prefira Server Components para busca; defina `revalidate` ou cache explícito e nunca dependa de cache implícito indefinido.

---

## 3. SEO Técnico
1. **Metadata por rota**: `title`, `description`, `canonical` e Open Graph definidos no `metadata` do segmento.
2. **Arquivos obrigatórios**: `app/sitemap.ts` e `app/robots.ts` mantidos atualizados.
3. **Conteúdo indexável**: a landing deve renderizar conteúdo principal no servidor, sem depender de JavaScript no cliente.
4. **Semântica**: um único `h1` por página, hierarquia de headings consistente e dados estruturados JSON-LD quando aplicável.
5. **URLs**: canônicas, sem duplicidade de barra final e sem parâmetros de rastreamento indexáveis.

---

## 4. Acessibilidade (a11y)
- Contraste mínimo AA, foco visível e navegação completa por teclado.
- Todo input com `label` associado; erros anunciados via `aria-live`.
- Elementos interativos não semânticos recebem `role` e tratamento de teclado.
- Respeite `prefers-reduced-motion` em animações e transições.

---

## 5. Tipagem e Qualidade de Código
- TypeScript em modo `strict`; proibido `any` implícito ou `@ts-ignore` sem justificativa documentada.
- Props sempre tipadas; sem lógica de negócio em componentes de apresentação.
- `npm run lint` e `npm test` devem passar antes de qualquer commit.
- `npm run build` de produção sem warnings bloqueantes.

---

## 6. Testes
1. **Unitários** (Vitest/Jest) para regras de domínio, formatadores e validadores.
2. **Componentes** com Testing Library, priorizando comportamento observável pelo usuário em vez de detalhes de implementação.
3. **E2E** (Playwright) para jornadas críticas: cadastro, login, checkout e formulários de conversão.

---

## 7. Segurança e Entrega
1. **Validação no servidor**: toda entrada é validada e higienizada no backend (ex.: Zod), nunca apenas no cliente.
2. **Headers de segurança**: CSP, `X-Content-Type-Options` e `Referrer-Policy` configurados no `next.config`.
3. **Gate de release**: nenhum deploy sobe sem build de produção, lint e testes verdes na mesma revisão.
