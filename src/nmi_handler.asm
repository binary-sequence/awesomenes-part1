.include "constants.inc"

.segment "ZEROPAGE"
  .importzp day_state
  .importzp day_time
  .importzp frame_counter
  .importzp ppu_ctrl
  .importzp ppu_mask
  .importzp scroll_x
  .importzp wait_for_next_day_time

.segment "CODE"

  .export nmi_handler
  .proc nmi_handler
    PHA
    TXA
    PHA
    TYA
    PHA

    LDA #OAM
    STA OAMADDR
    LDX #.HIBYTE(OAM_BUFFER)
    STX OAMDMA

    ; Palettes
    LDA #$3F
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDX #0
    CPX day_time
    BNE skip_darkest
    .scope
      loop:
        LDA palettes_darkest,X
        STA PPUDATA
        INX
        CPX #8
        BNE loop
    .endscope
    skip_darkest:

    LDX #1
    CPX day_time
    BNE skip_dark
    LDX #0
    .scope
      loop:
        LDA palettes_dark,X
        STA PPUDATA
        INX
        CPX #8
        BNE loop
    .endscope
    skip_dark:

    LDX #2
    CPX day_time
    BNE skip_bright
    LDX #0
    .scope
      loop:
        LDA palettes_bright,X
        STA PPUDATA
        INX
        CPX #8
        BNE loop
    .endscope
    skip_bright:

    LDX #3
    CPX day_time
    BNE skip_brightest
    LDX #0
    .scope
      loop:
        LDA palettes_brightest,X
        STA PPUDATA
        INX
        CPX #8
        BNE loop
    .endscope
    skip_brightest:

    INC scroll_x
    BNE same_nametable
    ;     VPHBSINN
    LDA #%00000001
    EOR ppu_ctrl
    STA ppu_ctrl
    same_nametable:
    INC frame_counter
    LDA frame_counter
    CMP #49 ; PAL: 49, NTSC: 59
    BNE intra_sec
    LDA #0
    STA frame_counter

    DEC wait_for_next_day_time
    BEQ next_day_time
    JMP skip_day_time
    next_day_time:
    LDA #8
    STA wait_for_next_day_time
    LDY day_state
    CPY #0
    BEQ continue_sunrise
    DEC day_time
    BNE skip_sunrise
    DEC day_state
    JMP skip_sunrise
    continue_sunrise:
      INC day_time
      LDX day_time
      CPX #4
      BNE skip_sunset
      INC day_state
      DEC day_time
      DEC day_time
    skip_sunset:
    skip_sunrise:
    skip_day_time:

    intra_sec:

    LDA ppu_ctrl
    STA PPUCTRL
    LDA scroll_x
    STA PPUSCROLL
    LDA #0
    STA PPUSCROLL

    LDA ppu_mask
    STA PPUMASK

    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
  .endproc

.segment "RODATA"
  palettes_blank:
    .byte $0F,$0F,$0F,$0F, $0F,$0F,$0F,$0F
  palettes_darkest:
    .byte $0C,$0F,$07,$01, $0C,$0F,$00,$01
  palettes_dark:
    .byte $1C,$0F,$06,$11, $1C,$0F,$10,$11
  palettes_bright:
    .byte $2C,$0F,$16,$21, $2C,$0F,$20,$21
  palettes_brightest:
    .byte $3C,$0F,$17,$31, $3C,$0F,$30,$31
