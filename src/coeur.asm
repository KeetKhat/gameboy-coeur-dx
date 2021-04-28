coeur:
	call wait_vblank
	call lcd_off
	call load_fonts

	; Background position

	ld a, $05
	ldh [$43], a ; SCX


	; Window position

	ld a, $70
	ldh [$4A], a ; WY
	ld a, $05
	ldh [$4B], a ; WX


	; DMG Palette

	ld a, %11100100 ; PAL
	ldh [$47], a


	; CGB Palette

	ld b, 8
	ld hl, pal
	call load_pal_bg


	; ---------------------------
	; -							-
	; -     MEMORY CLEANING     -
	; -							-
	; ---------------------------


	; ----- OAM -----

	ld de, 4*40
	ld hl, $FE00 ; OAM Location
	call clear_mem


	; ----- MAP -----

	ld de, 32*32
	ld hl, $9800
	call clear_mem


	; ----- MEM COPY -----

	; Copie tiles coeur dans la VRAM

	ld bc, 16*3
	ld de, $8310
	ld hl, coeur_tiles
	call copy_mem


	; Copie tiles coeur sur la map

	ld b, 15
	ld c, 12
	ld de, $9843
	ld hl, coeur_map
	call load_map


	; Copie prénom sur la map

	ld hl, $9C25
	ld de, texte.prenom
	call display_text

	ld a, %11110001
	ldh [$40], a ; LCD Location

loop_coeur:
	ldh a, [$42]
	inc a
	ldh [$42], a
	ld bc, 15
	call delay_frames

	ldh a, [$42]
	inc a
	ldh [$42], a
	ld bc, 15
	call delay_frames

	ldh a, [$42]
	inc a
	ldh [$42], a
	ld bc, 15
	call delay_frames


	ldh a, [$42]
	dec a
	ldh [$42], a
	ld bc, 15
	call delay_frames

	ldh a, [$42]
	dec a
	ldh [$42], a
	ld bc, 15
	call delay_frames

	ldh a, [$42]
	dec a
	ldh [$42], a
	ld bc, 15
	call delay_frames
	jr loop_coeur
