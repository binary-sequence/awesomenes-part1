.include "constants.inc"

.segment "ZEROPAGE"
  .importzp day_state
  .importzp day_time
  .importzp frame_counter
  .importzp index
  .importzp ppu_ctrl
  .importzp ppu_mask
  .importzp scroll_x
  .importzp state
  .importzp vram_hibyte
  .importzp vram_lobyte
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

    LDA #0
    CMP state
    BEQ preload_first_line
    JMP skip_first_line
    preload_first_line:
      INC state
      LDA #$25
      STA PPUADDR
      LDA #$80
      STA PPUADDR
      LDX #0
      .scope
        loop:
          LDA text0,X
          CMP #$00
          BEQ exit_loop
          STA PPUDATA
          INX
          JMP loop
          exit_loop:
      .endscope
    skip_first_line:

    LDA #1
    CMP state
    BEQ first_line_already_loaded
    JMP wait_for_scroll
    first_line_already_loaded:
      LDA #255
      CMP scroll_x
      BNE wait_for_scroll
      LDA vram_hibyte
      STA PPUADDR
      LDA vram_lobyte
      STA PPUADDR
      LDX index
      .scope
        loop:
          LDA text1,X
          CMP #$00
          BEQ exit_loop
          STA PPUDATA
          INX
          JMP loop
          exit_loop:
      .endscope
      INX
      BNE continue_1
      INC state
      continue_1:
      STX index
      LDA vram_hibyte
      CLC
      ADC #4
      STA vram_hibyte

    LDA #2
    CMP state
    BEQ first_text_already_loaded
    JMP wait_for_scroll
    first_text_already_loaded:
      LDA #255
      CMP scroll_x
      BNE wait_for_scroll
      LDA vram_hibyte
      STA PPUADDR
      LDA vram_lobyte
      STA PPUADDR
      LDX index
      .scope
        loop:
          LDA text2,X
          CMP #$00
          BEQ exit_loop
          STA PPUDATA
          INX
          JMP loop
          exit_loop:
      .endscope
      INX
      BNE continue_2
      INC state
      continue_2:
      STX index
      LDA vram_hibyte
      CLC
      ADC #4
      STA vram_hibyte

    wait_for_scroll:

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
    .byte $0F,$0F,$0F,$30, $0F,$0F,$0F,$0F
  palettes_darkest:
    .byte $0C,$0F,$07,$30, $0C,$0F,$00,$01
  palettes_dark:
    .byte $1C,$0F,$06,$30, $1C,$0F,$10,$11
  palettes_bright:
    .byte $2C,$0F,$16,$30, $2C,$0F,$20,$21
  palettes_brightest:
    .byte $3C,$0F,$17,$30, $3C,$0F,$30,$31
  text0:
    .asciiz "MADE WITH NATURAL 6502 ASSEMBLER"
  text1:
    .asciiz ", NO ARTIFICIAL HIGH-LEVEL LANGU"
    .asciiz "AGES ADDED. NOW YOU ARE DEMOING "
    .asciiz "WITH POWER.                     "
    .asciiz "AWE! SOME NES - PART 1 - BINARY-"
    .asciiz "SEQUENCE (CODE, GRAPHICS).      "
    .asciiz "MOOVIE (MUSIC)                  "
    .asciiz "WAIT FOR PART 2,   NEXT YEAR... "
    .asciiz "  THANK YOU, MOUNTAINBYTES 2024!"
  text2:
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
    .asciiz "                                "
