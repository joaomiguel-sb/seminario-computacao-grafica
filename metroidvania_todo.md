# To-Do List — Metroidvania + Beat 'em Up

Organizado na ordem lógica de desenvolvimento. Requisitos acadêmicos estão no topo.

---

## 1. Setup do Projeto

- [x] Criar projeto no Godot 4.4.X — RNF01
- [x] Configurar target PC (Windows) — RNF02
- [x] Definir estrutura de pastas e cenas do projeto

## 2. Transformações Geométricas (Requisito Acadêmico — Prioridade Máxima)

- [ ] Aplicar translação (movimentação de objetos) — RF20
- [ ] Aplicar rotação — RF20
- [x] Aplicar escala — RF20
- [x] Aplicar reflexão (flip/espelhamento) — RF20

> Todas as transformações são obrigatórias. Trabalhos que não implementarem todas terão impacto na avaliação.

## 3. Personagem e Movimentação

- [ ] Criar sprite do personagem principal em pixel art — RNF05
- [ ] Implementar movimentação em 8 direções (WASD/setas) — RF01
- [x] Implementar pulo (Barra de Espaço) — RF06
- [ ] Implementar agachar (Shift/C) — RF06
- [ ] Mapear controles de teclado completos (Z/N normal, X/M especial) — RF07
- [ ] Implementar colisão com paredes e obstáculos

## 4. Sistema de Combate

- [ ] Criar sprite de pelo menos 1 tipo de inimigo — RNF05
- [ ] Implementar ataque normal (chão, agachado e aéreo) — RF02
- [ ] Implementar estado de combo ao acertar ataque — RF03
- [ ] Implementar janela de combo pós hit-stun (pequeno intervalo após o fim do hit-stun) — RF05
- [ ] Garantir hit-stun generoso para gameplay fluida — RNF06
- [ ] Balancear dano: normal = 1, especial = 2~3 — RNF08

## 5. Vida, Morte e Checkpoints

- [ ] Implementar barra de vida do jogador — RF11
- [ ] Implementar recebimento de dano — RF11
- [ ] Implementar morte/desmaio ao zerar a vida — RF12
- [ ] Implementar checkpoints com salvamento de progresso — RF10
- [ ] Implementar respawn no último checkpoint — RF12

## 6. Level Design

- [ ] Projetar salas longas com checkpoints escassos — RNF12
- [ ] Implementar transição entre salas
- [ ] Garantir sessão de 1 a 5 minutos no protótipo — RNF07

## 7. Boss e Progressão

- [ ] Criar sprite do boss — RNF05
- [ ] Implementar IA e padrões de ataque do boss — RF13
- [ ] Implementar desbloqueio de habilidade ao derrotar boss — RF13
- [ ] Habilidade nova deve abrir acesso a área bloqueada — RF14

## 8. HUD e Menus

- [ ] Implementar HUD com barra de vida — RF21
- [ ] Implementar tela de pause — RF21
- [ ] Implementar menu simples (iniciar, sair) — RF21

## 9. Arte e Polimento

- [ ] Estilo visual consistente: pixel art arcade 2D side-scroller — RNF03
- [ ] Animações fluidas para movimentação e ataques — RNF11
- [ ] Efeitos em pixel art para ataques especiais — RNF11

## 10. Validação Final

- [ ] Verificar que todas as 4 transformações geométricas estão aplicadas — RF20
- [ ] Testar sessão completa de 1–5 min — RNF07
- [ ] Garantir que o projeto está funcional para a apresentação — RNF09

---

## Desejável (após o essencial pronto)

- [ ] Suportar gamepad Sony/Xbox — RF08
- [ ] Mapa interconectado com salas de layouts variados — RF09
- [ ] Aumento de stats via exploração, NPCs e sidequests — RF16
- [ ] Paleta de cores: tons frios ambiente, quentes poderes — RNF04
- [ ] Feedback sonoro: dano, acerto, derrota — RNF10

## Opcional

- [ ] Sistema de economia (drop de dinheiro) — RF15
- [ ] Lojas no mapa — RF17
- [ ] Uso de itens via teclas 1–4 / D-Pad — RF18
- [ ] Multiplayer local cooperativo (2 jogadores) — RF19

---

## Entregáveis

- [ ] Código-fonte no GitHub
- [ ] Artigo em formato PDF
- [ ] Slides da apresentação
