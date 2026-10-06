---
id: "T03"
title: "Push notifications com deep links"
target: "mobile"
difficulty: 3
urgency: 3
status: "todo"
spec: "_specs/features/push-notifications.md"
---

# T03: Push notifications com deep links

## Contexto
- Reengajamento depende de notificações que levam o usuário direto à tela certa.
- Escopo: FCM (Android/iOS), APNs via FCM, notificações locais e roteamento por deep link.

## Escopo
- [ ] Registro de device tokens e tópicos por usuário.
- [ ] Recebimento em foreground/background/terminado com os 4 estados onde houver UI.
- [ ] Deep links abrindo a rota correta com fallback para home.
- [ ] Tela de preferências de notificação (opt-in/out por categoria).
