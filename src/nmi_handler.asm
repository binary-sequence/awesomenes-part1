.include "constants.inc"

.segment "ZEROPAGE"
  .importzp ppu_ctrl
  .importzp ppu_mask

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

    LDA ppu_ctrl
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL
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
