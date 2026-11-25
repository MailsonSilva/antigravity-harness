# DESIGN SYSTEM — Fonte Única de Verdade Visual

> **Regra:** Antes de criar ou editar qualquer tela/widget, consulte este arquivo. É proibido usar cores literais (`Color(0x...)`, `Colors.blue`), fontes ou espaçamentos mágicos fora de `lib/core/theme/`.

---

## 1. Identidade e Direção Visual
- **Produto / Marca:** `[Nome do App]`
- **Estilo Visual:** `[Minimalista / Corporativo / High-Contrast / Editorial]`
- **Temas Suportados:** `Light Mode` e `Dark Mode` (automático via sistema ou preferência do usuário)
- **Referências Visuais:** `_references/screens/`

---

## 2. Paleta de Cores (Tokens Semânticos)

| Token Semântico | Light Mode (Hex) | Dark Mode (Hex) | Uso Principal |
|---|---|---|---|
| `primary` | `#0EA5E9` | `#38BDF8` | Ações principais, botões primários, destaques |
| `onPrimary` | `#FFFFFF` | `#04101E` | Texto e ícones sobre `primary` |
| `secondary` | `#6366F1` | `#818CF8` | Ações secundárias, badges e acentos |
| `background` | `#F8FAFC` | `#090D16` | Fundo base das telas (`Scaffold`) |
| `surface` | `#FFFFFF` | `#111726` | Cards, AppBars, BottomSheets e modais |
| `surfaceVariant` | `#F1F5F9` | `#182238` | Inputs, containers secundários e skeletons |
| `textPrimary` | `#0F172A` | `#F1F5F9` | Títulos, valores principais e corpo padrão |
| `textSecondary` | `#475569` | `#94A3B8` | Subtítulos, labels e textos auxiliares |
| `border` | `#E2E8F0` | `#232F48` | Divisores, bordas de cards e inputs |
| `success` | `#10B981` | `#34D399` | Confirmações, status concluído/positivo |
| `warning` | `#F59E0B` | `#FBBF24` | Alertas, atenção e pendências |
| `error` | `#EF4444` | `#FB7185` | Falhas, validações e ações destrutivas |

---

## 3. Tipografia
- **Família Principal (UI & Corpo):** `[Inter / Plus Jakarta Sans / Roboto]` (via `google_fonts` ou local)
- **Família Secundária (Display / Numérica):** `[Mesma da principal ou JetBrains Mono para valores]`

| Estilo (`TextTheme`) | `fontSize` | `fontWeight` | `height` | `letterSpacing` | Uso |
|---|---|---|---|---|---|
| `displayLarge` | `32` | `700` | `1.20` | `-0.5` | Hero / valores totais em destaque |
| `headlineMedium` | `24` | `700` | `1.25` | `-0.25` | Títulos de seção e onboarding |
| `titleLarge` | `20` | `600` | `1.30` | `0.0` | Títulos de AppBar e modais |
| `bodyLarge` | `16` | `400` | `1.50` | `0.15` | Texto principal e descrições |
| `bodyMedium` | `14` | `400` | `1.45` | `0.25` | Texto secundário e itens de lista |
| `labelLarge` | `14` | `600` | `1.20` | `0.1` | Botões, chips e badges |

---

## 4. Espaçamento e Grid (Base 4px / 8px)
- **Tokens (`AppTokens`):** `xs: 4`, `sm: 8`, `md: 16`, `lg: 24`, `xl: 32`, `xxl: 48`
- **Padding horizontal padrão de tela:** `md` (`16`) em smartphones, `lg` (`24`) em tablets
- **Gap padrão entre cards/itens de lista:** `sm` (`8`) ou `md` (`16`)
- **Área mínima de toque:** `48x48 dp` em todo controle interativo

---

## 5. Formas, Bordas e Elevação
- **Raio de borda (`borderRadius`):** `sm: 6`, `md: 12`, `lg: 16`, `full: 999`
- **Espessura de borda padrão:** `1.0` (foco em inputs: `1.5`)
- **Elevação / Sombra:**
  - `level0`: `0` (flat com borda `1px` em `border`)
  - `level1`: sombra suave (`blurRadius: 8`, `offset: (0, 2)`, opacidade `0.06`) para cards elevados
  - `level2`: sombra modal (`blurRadius: 20`, `offset: (0, 8)`, opacidade `0.16`) para BottomSheets/Dialogs

---

## 6. Padrões de Componentes
- **Botões:**
  - *Primário (`FilledButton` / `ElevatedButton`):* fundo `primary`, texto `onPrimary`, altura mínima `48`, `radius: md`.
  - *Secundário (`OutlinedButton`):* borda `border`, fundo transparente, texto `textPrimary`, altura mínima `48`.
  - *Ghost (`TextButton`):* sem borda, texto `primary`, área de toque mínima `48`.
- **Inputs (`InputDecorationTheme`):** fundo `surfaceVariant`, borda `border` (`radius: md`), foco em `primary` (`1.5px`), erro em `error`.
- **Cards (`CardTheme`):** fundo `surface`, borda `border` (`1px`), `radius: md`, padding interno `md` (`16`).
- **AppBar (`AppBarTheme`):** fundo `background` ou `surface`, `elevation: 0`, título em `titleLarge`.
- **BottomNavigation (`NavigationBarTheme`):** fundo `surface`, borda superior `border`, indicador `primary` com `15%` de opacidade.
