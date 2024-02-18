.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
  day_state: .res 1  ; 0: sunrise, 1: sunset
  day_time: .res 1  ; 0: darkest, 1: dark, 2: bright, 3: brightest
  frame_counter: .res 1
  p1_buttons: .res 1
  p1_buttons_last_pressed: .res 1
  ppu_ctrl: .res 1
  ppu_mask: .res 1
  scroll_x: .res 1
  .exportzp day_state
  .exportzp day_time
  .exportzp frame_counter
  .exportzp p1_buttons
  .exportzp p1_buttons_last_pressed
  .exportzp ppu_ctrl
  .exportzp ppu_mask
  .exportzp scroll_x

.segment "OAMBUFFER"
  .res 256

.segment "BSS"
  .res 256

.segment "CODE"
  .import draw_dock
  .import draw_mountains
  .import draw_sky
  .import irq_handler
  .import nmi_handler
  .import reset_handler

  .export main
  .proc main
    JSR draw_sky
    JSR draw_mountains
    JSR draw_dock

    ; Attribute tables
    LDA #$23
    STA PPUADDR
    LDA #$C0
    STA PPUADDR
    ;     BrBlTrTl
    LDA #%01010101
    LDX #(8 * 2)
    .scope
      loop:
        STA PPUDATA
        DEX
        BNE loop
    .endscope

    LDA #$27
    STA PPUADDR
    LDA #$C0
    STA PPUADDR
    ;     BrBlTrTl
    LDA #%01010101
    LDX #(8 * 2)
    .scope
      loop:
        STA PPUDATA
        DEX
        BNE loop
    .endscope


    LDA #0
    STA day_state
    STA day_time
    STA frame_counter
    STA scroll_x

    ;     BGRsbMmG
    LDA #%00011110
    STA ppu_mask
    STA PPUMASK

    BIT PPUSTATUS
    ;     VPHBSINN
    LDA #%10001000
    STA ppu_ctrl
    STA PPUCTRL

    forever:
      JMP forever
  .endproc

.segment "VECTORS"
  .addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
  .incbin "../res/pattern_tables.chr"
