INCLUDE "header/rst.asm"
INCLUDE "header/interrupts.asm"
INCLUDE "header/header.asm" ; Cartridge header
INCLUDE "system/hram.asm" ; HRAM Variables
INCLUDE "system/wram.asm" ; WRAM Variables

INCLUDE "graphics/fonts.asm" ; Gestion du texte

Section "Coeur", ROM0[$150]
main:

	ld a, %00000001
	ldh [$FF], a ; V-Blank INT
	ei


	; ---------------------------
	; -							-
	; -     MEMORY CLEANING     -
	; -							-
	; ---------------------------


	; ----- WRAM -----

	ld de, 8*1024
	ld hl, $C000 ; WRAM0 Location
	call clear_mem


	; ----- HRAM -----

	ld de, 8*15
	ld hl, $FF80 ; HRAM Location
	call clear_mem

	; ---------------------------
	; -							-
	; -           END           -
	; -							-
	; ---------------------------


INCLUDE "coeur.asm"

no_op:
	halt
	nop
	jp no_op

INCLUDE "system/routines.asm"
INCLUDE "graphics/lcd.asm"

SECTION "Tiles & Stuff", ROMX[$4000]

INCLUDE "graphics/palettes.asm"
INCLUDE "graphics/tiles.asm"
INCLUDE "graphics/map.asm"

INCLUDE "graphics/text/text.asm"