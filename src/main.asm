.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
  p1_buttons: .res 1
  p1_buttons_last_pressed: .res 1
  ppu_ctrl: .res 1
  ppu_mask: .res 1
  .exportzp p1_buttons
  .exportzp p1_buttons_last_pressed
  .exportzp ppu_ctrl
  .exportzp ppu_mask

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

    ; Palettes
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #0
    .scope
      loop:
        LDA palettes1,X
        STA PPUDATA
        INX
        CPX #16
        BNE loop
    .endscope

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

.segment "RODATA"
  palettes_blank:
    .byte $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F
  palettes_darkest:
    .byte $0C,$0F,$07,$01, $0F,$0F,$00,$01
  palettes_dark:
    .byte $1C,$0F,$06,$11, $0F,$0F,$10,$11
  palettes_bright:
    .byte $2C,$0F,$16,$21, $0F,$0F,$20,$21
  palettes_brightest:
    .byte $3C,$0F,$17,$31, $0F,$0F,$30,$31
  palette1: .incbin "res/palette1.pal"

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "../res/pattern_tables.chr"
