.include "nes_constants.inc"

.segment "ZEROPAGE"
.importzp p1_buttons
.importzp p1_buttons_last_pressed

.segment "CODE"

.export clear_nametables
.proc clear_nametables
  LDA #.HIBYTE(NT0)
  STA PPUADDR
  LDA #.LOBYTE(NT0)
  STA PPUADDR
  LDX #0
  LDY #8
  clear:
    ; 256 * 8 = 2048
    STA PPUDATA
    INX
    BNE clear
    DEY
    BNE clear

  RTS
.endproc

.export clear_oam_buffer
.proc clear_oam_buffer
  LDA #$FF
  LDX #0
  clear:
    STA $200,X
    INX
    INX
    INX
    INX
    BNE clear

  RTS
.endproc

.export clear_screen
.proc clear_screen
  JSR clear_nametables
  JSR clear_oam_buffer
.endproc

.export read_joy1
.proc read_joy1
  LDA p1_buttons
  STA p1_buttons_last_pressed
  LDA #1
  STA JOY1 ; read
  STA p1_buttons
  LSR A
  STA JOY1 ; latch
  loop:
    LDA JOY1
    LSR A
    ROL p1_buttons
    BCC loop

  RTS
.endproc
