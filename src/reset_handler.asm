.include "constants.inc"

.segment "CODE"
  .import clear_nametables
  .import clear_oam_buffer
  .import main

  .export reset_handler
  .proc reset_handler
    SEI ; Disable IRQ
    CLD ; Disable decimal mode
    LDX #%01000000
    STX JOY2 ; disable APU frame IRQ
    LDX #$FF
    TXS ; clear stack
    INX ; #0
    STX PPUCTRL ; do not serve NMIs
    STX PPUMASK ; disable PPU drawing
    STX DMC_FREQ ; disable DMC

    BIT PPUSTATUS
    vblankwait1:
      BIT PPUSTATUS
      BPL vblankwait1

    JSR clear_oam_buffer

    LDA #0
    clear_ram:
      STA $000,X
      STA $100,X
      STA $300,X
      STA $400,X
      STA $500,X
      STA $600,X
      STA $700,X
      INX
      BNE clear_ram

    vblankwait2:
      BIT PPUSTATUS
      BPL vblankwait2

    JSR clear_nametables

    JMP main
  .endproc
