ASM	:= rgbasm
LINKER := rgblink
FIX := rgbfix

ROM_NAME := gb_coeur_dx

all:
	$(ASM) -o ../$(ROM_NAME).obj main.asm
	$(LINKER) -p 0x0 -m ../$(ROM_NAME).map -n ../$(ROM_NAME).sym -o ../$(ROM_NAME).gbc ../$(ROM_NAME).obj
	$(FIX) -s -v -c -j -l 0x33 -r 0 -p 0 -t "$(ROM_NAME)" ../$(ROM_NAME).gbc
