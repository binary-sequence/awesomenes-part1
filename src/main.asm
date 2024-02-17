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
  .import irq_handler
  .import nmi_handler
  .import reset_handler

  .export main
  .proc main
    ; Sky
    LDA #$20
    STA PPUADDR
    LDA #00
    STA PPUADDR
    LDY #$02
    LDX #(32 * 7)
    .scope
      draw_sky:
        STY PPUDATA
        DEX
        BNE draw_sky
    .endscope

    ; Mountains
    ; $200F
    LDA #$20
    STA PPUADDR
    LDA #$0F
    STA PPUADDR
    LDX #$07
    STX PPUDATA
    ; $202E
    LDA #$20
    STA PPUADDR
    LDA #$2E
    STA PPUADDR
    LDY #$05
    STY PPUDATA
    LDY #$01
    STY PPUDATA
    LDY #$06
    STY PPUDATA
    ; $2037
    LDA #$20
    STA PPUADDR
    LDA #$37
    STA PPUADDR
    LDY #$05
    STY PPUDATA
    INY
    STY PPUDATA
    ; $2044
    LDA #$20
    STA PPUADDR
    LDA #$44
    STA PPUADDR
    LDY #$07
    STY PPUDATA
    ; $204D
    LDA #$20
    STA PPUADDR
    LDA #$4D
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDX #$20
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    INY
    STY PPUDATA
    ; $2056
    LDA #$20
    STA PPUADDR
    LDA #$56
    STA PPUADDR
    LDY #$05
    STY PPUDATA
    LDX #$01
    STX PPUDATA
    STX PPUDATA
    INY
    STY PPUDATA
    ; $2063
    LDA #$20
    STA PPUADDR
    LDA #$63
    STA PPUADDR
    LDY #$05
    STY PPUDATA
    LDX #$01
    STX PPUDATA
    INY
    STY PPUDATA
    ; $206C
    LDA #$20
    STA PPUADDR
    LDA #$6C
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDX #$20
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    INY
    STY PPUDATA
    ; $2075
    LDA #$20
    STA PPUADDR
    LDA #$75
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDX #$20
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    INY
    STY PPUDATA
    ; $2082
    LDA #$20
    STA PPUADDR
    LDA #$82
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDX #$20
    STX PPUDATA
    STX PPUDATA
    STX PPUDATA
    INY
    STY PPUDATA
    ; $208B
    LDA #$20
    STA PPUADDR
    LDA #$8B
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDY #$20
    LDX #7
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY #$04
    STY PPUDATA
    DEY
    STY PPUDATA
    LDY #$20
    LDX #6
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY # $04
    STY PPUDATA
    ; $20A1
    LDA #$20
    STA PPUADDR
    LDA #$A1
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDY #$20
    LDX #5
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY #$04
    STY PPUDATA
    ; $20AA
    LDA #$20
    STA PPUADDR
    LDA #$AA
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDY #$20
    LDX #17
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY #$04
    STY PPUDATA
    ; $20BF
    LDA #$20
    STA PPUADDR
    LDA #$BF
    STA PPUADDR
    LDY #$03
    STY PPUDATA

    ; $20C0
    LDA #$20
    STA PPUADDR
    LDA #$C0
    STA PPUADDR
    LDY #$03
    STY PPUDATA
    LDY #$20
    LDX #7
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY #$04
    STY PPUDATA
    DEY
    STY PPUDATA
    LDY #$20
    LDX #19
    .scope
      draw_mountains:
        STY PPUDATA
        DEX
        BNE draw_mountains
    .endscope
    LDY #$04
    STY PPUDATA
    DEY
    STY PPUDATA
    LDY #$20
    STY PPUDATA
    LDA #$20
    STA PPUADDR
    LDA #$E0
    STA PPUADDR
    LDA #$20
    LDX #96
    write_line:
      STA PPUDATA
      DEX
      BNE write_line
    LDY #$20
    LDX #8
    .scope
      draw_coast:
        STY PPUDATA
        INY
        DEX
        BNE draw_coast
    .endscope
    DEY
    DEY
    STY PPUDATA
    DEY
    STY PPUDATA
    STY PPUDATA
    INY
    STY PPUDATA
    STY PPUDATA
    INY
    STY PPUDATA
    STY PPUDATA
    LDA #$21
    STA PPUADDR
    LDA #$2F
    STA PPUADDR
    LDY #$20
    LDX #5
    .scope
      draw_coast:
        STY PPUDATA
        INY
        DEX
        BNE draw_coast
    .endscope
    DEY
    LDX #5
    .scope
      draw_coast:
        STY PPUDATA
        DEY
        DEX
        BNE draw_coast
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$58
    STA PPUADDR
    LDY #$27
    STY PPUDATA
    STY PPUDATA
    DEY
    STY PPUDATA
    STY PPUDATA
    DEY
    STY PPUDATA
    DEY
    STY PPUDATA
    STY PPUDATA
    STY PPUDATA

    ; Dock
    ;     VPHBSINN
    LDA #%00000100
    STA PPUCTRL
    LDA #$22
    STA PPUADDR
    LDA #$CC
    STA PPUADDR
    LDY #$17
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEY
        DEX
        BNE draw_dock
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$CD
    STA PPUADDR
    LDY #$17
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEY
        DEX
        BNE draw_dock
    .endscope
    LDY #$1
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEX
        BNE draw_dock
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$AE
    STA PPUADDR
    LDA #$2F
    STA PPUDATA
    LDX #16
    .scope
      draw_dock:
        STY PPUDATA
        DEX
        BNE draw_dock
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$AF
    STA PPUADDR
    LDA #$2F
    STA PPUDATA
    LDX #16
    .scope
      draw_dock:
        STY PPUDATA
        DEX
        BNE draw_dock
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$B0
    STA PPUADDR
    LDA #$2F
    STA PPUDATA
    LDX #16
    .scope
      draw_dock:
        STY PPUDATA
        DEX
        BNE draw_dock
    .endscope
    LDA #$21
    STA PPUADDR
    LDA #$D1
    STA PPUADDR
    LDY #$1F
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEY
        DEX
        BNE draw_dock
    .endscope
    LDY #$1
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEX
        BNE draw_dock
    .endscope
    LDA #$22
    STA PPUADDR
    LDA #$D2
    STA PPUADDR
    LDY #$1F
    LDX #8
    .scope
      draw_dock:
        STY PPUDATA
        DEY
        DEX
        BNE draw_dock
    .endscope
    ;     VPHBSINN
    LDA #%00000000
    STA PPUCTRL

    ; Attribute table
    LDA #$23
    STA PPUADDR
    LDA #$C0
    STA PPUADDR
    ;     BrBlTrTl
    LDA #%01010101
    LDX #(8 * 2)
    set_palette:
      STA PPUDATA
      DEX
      BNE set_palette

    ; Palette 1
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #0
    write_palette1:
      LDA palette1,X
      STA PPUDATA
      INX
      CPX #16
      BNE write_palette1

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
  palette1: .incbin "res/palette1.pal"

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "../res/pattern_tables.chr"
