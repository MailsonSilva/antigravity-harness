---
name: web-performance-seo
description: Otimização de Core Web Vitals, renderização no servidor e SEO técnico em aplicações React/Next.js. Use ao criar rotas, componentes pesados ou revisar performance, indexação e acessibilidade do web.
---

# Skill: Performance Web e SEO Técnico

Esta skill orienta a construção e a revisão de aplicações web em `apps/web/` e `apps/landing/`, sempre subordinada às regras de `.agents/rules/web.md` e `.agents/rules/global.md`.

## 1. Gatilho de Ativação
Acione quando:
- Uma nova rota, layout ou landing page for criada.
- Houver regressão de Core Web Vitals ou aumento do bundle.
- For necessário revisar indexação, metadata ou dados estruturados.

## 2. Fluxo de Trabalho
1. **Medir antes de otimizar**:
   - Execute o build de produção e registre `LCP`, `INP` e `CLS` (p75 mobile).
   - Identifique o maior contribuinte do bundle com análise de build.
2. **Corrigir a causa raiz**:
   - Dados buscados em Server Components quando não houver interatividade.
   - `dynamic import` para bibliotecas pesadas; `next/image` e `next/font` sempre.
   - Elimine dependências duplicadas e código de cliente desnecessário.
3. **Validar SEO técnico**:
   - `metadata` por rota, `canonical`, `sitemap.ts` e `robots.ts` presentes.
   - Conteúdo principal renderizado no servidor; um único `h1`.
4. **Revalidar**:
   - Rebuild + nova medição; compare com a linha de base registrada.
   - `npm run lint` e `npm test` verdes antes de encerrar.

## 3. Checklist de Aceitação
- [ ] `LCP` ≤ 2,5 s, `INP` ≤ 200 ms e `CLS` ≤ 0,1 no p75 mobile.
- [ ] Nenhum segredo ou chave privada no bundle do cliente.
- [ ] Rotas commetadata única e canônica; `sitemap` e `robots` atualizados.
- [ ] Imagens com dimensões explícitas e formatos modernos.
- [ ] Navegação por teclado e contraste AA preservados.

## 4. Anti-Padrões
- `"use client"` no topo de árvores inteiras sem necessidade real.
- `fetch` em componente de apresentação ou acesso direto a SDK no cliente.
- Otimização baseada em percepção, sem medição antes/depois.
