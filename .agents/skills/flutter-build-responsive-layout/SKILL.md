---
name: flutter-build-responsive-layout
description: Construção de layouts adaptativos e responsivos em Flutter para smartphones pequenos, grandes e tablets usando LayoutBuilder, MediaQuery.sizeOf e Slivers.
category: UI/UX & Frontend
---

# Skill: Responsive & Adaptive Layouts em Flutter

## 1. Regras de Responsividade
1. **Use `MediaQuery.sizeOf(context)`** em vez de `MediaQuery.of(context).size` para evitar rebuilds desnecessários quando o teclado abre.
2. **Breakpoints Canônicos**:
   - Compacto (Celular): `< 600dp` (Lista em 1 coluna, BottomNavigationBar).
   - Médio (Tablet Vertical / Dobrável): `600dp – 839dp` (Grid de 2 colunas, NavigationRail).
   - Expandido (Tablet Horizontal / Desktop): `>= 840dp` (Layout Master-Detail lado a lado).
3. **Prevenção de Overflow em Modais/BottomSheets**: Todo `BottomSheet` com campos de texto deve envolver seu conteúdo em `SingleChildScrollView` + `Padding(padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom))`.
