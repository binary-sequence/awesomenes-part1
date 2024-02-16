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
    JSR load_start_screen
    JSR load_game
  .endproc

.segment "RODATA"
  .res 256

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "../res/pattern_tables.chr"
