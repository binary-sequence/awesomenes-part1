NAME = awesomenes-part1
AS = ca65 --verbose
LD = ld65 -v -C $(NES_CFG)
OBJECTS = build/obj/demo.o build/obj/irq_handler.o build/obj/main.o build/obj/nmi_handler.o build/obj/reset_handler.o build/obj/utils.o
DEBUG_OBJECTS = build/debug/demo.o build/debug/irq_handler.o build/debug/main.o build/debug/nmi_handler.o build/debug/reset_handler.o build/debug/utils.o
RESOURCES = res/palette1.pal res/pattern_tables.chr
NES_CFG = ./nes.cfg
ROM_NAME = $(NAME).nes
DBG_NAME = $(NAME).dbg


########################################################################
#                         RELEASE BUILD

.PHONY: release
release: build/dist/$(ROM_NAME)

build/dist/$(ROM_NAME): $(OBJECTS) $(NES_CFG) build/dist
	$(LD) -o $@ $(OBJECTS)

build/dist:
	mkdir -p build/dist

$(OBJECTS): build/obj/%.o: src/%.asm $(RESOURCES) build/obj
	$(AS) -o $@ $<

build/obj:
	mkdir -p build/obj

.PHONY: run
run: build/dist/$(ROM_NAME)
	fceux build/dist/$(ROM_NAME)

.PHONY: everdrive
everdrive: build/dist/$(ROM_NAME)
	edlinkn8.py build/dist/$(ROM_NAME)
########################################################################


########################################################################
#                          DEBUG BUILD

.PHONY: debug
debug: build/debug/$(ROM_NAME) build/debug/$(DBG_NAME)
	mesen build/debug/$(ROM_NAME)

build/debug/$(ROM_NAME): $(DEBUG_OBJECTS) $(NES_CFG) build/debug
	$(LD) --dbgfile build/debug/$(DBG_NAME) -o $@ $(DEBUG_OBJECTS)

build/debug:
	mkdir -p build/debug

$(DEBUG_OBJECTS): build/debug/%.o: src/%.asm $(RESOURCES) build/debug
	$(AS) -g -o $@ $<
########################################################################


.PHONY: clean
clean:
	rm -rf build/
