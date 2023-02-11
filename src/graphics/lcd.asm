; ----- V-Blank -----

vblank:

	push af
	push bc
	push de
	push hl

	; V-Blank flag = $FF80
	ld a, 1
	ldh [vblank_flag], a

	; Frame counter = $FF81
	ld hl, frame_counter
	inc [hl]

	pop hl
	pop de
	pop bc
	pop af
	ret

wait_vblank:
	ld hl, vblank_flag
	xor a
.wait
	halt
	nop
	cp [hl] ; On vérifie si "vblank_flag" est égal à zéro
	jr z, .wait ; Si c'est le cas, le v-blank n'a pas encore eu lieu, on recommence la boucle
	ld [hl], a
	ret

; BC = Frames à attendre
delay_frames:
	call delay_frame
	dec bc
	ld a, b
	or c
	jp nz, delay_frames
	ret

delay_frame:
	ld hl, vblank_flag
	xor a
	ld [hl], a
	halt ; Reduce CPU Usage
	nop
.wait_until_zero
	ld a, [hl]
	and a
	jp z, .wait_until_zero
	ret

; ----- Gestion du LCD -----

lcd_off:
	ld a, %00010001 ; LCD OFF, Tile Map = $9800, Window OFF, BG Tile Data = $8000, BG Tile Map = 9800, Sprite 8x8, Sprite OFF, BG ON
	ldh [$40], a
	ret

lcd_on_9800:
	ld a, %10010001 ; LCD ON, Tile Map = $9800, Window OFF, BG Tile Data = $8000, BG Tile Map = 9800, Sprite 8x8, Sprite OFF, BG ON
	ldh [$40], a
	ret

; ----- Gestion de la VRAM -----

load_fonts: ; Le label parle de lui même
	ld hl, fonts
	ld de, $8010
	ld bc, 45*16
	call copy_mem
	ret

; B = Largeur
; C = Hauteur
; DE = Adresse de destination de la map
; HL = Label de la map
load_map:
	push de ; On envoie l'adresse dans la pile du CPU
	push bc ; Idem pour les dimensions
.map_nopush ; On va dessiner une ligne
	ld a, [hli] ; On met le premier octet dans A
	ld [de], a ; A = DE
	inc de ; On incrémente DE
	dec b ; On décremente la largeur
	xor a ; A = 0
	cp b ; On vérifie si la largeur est égal à 0
	jp nz, .map_nopush ; Si la ligne n'est pas terminée (Largeur != 0) on recommence
	jp z, .height ; Autrement on va à .height
.height
	pop bc ; On obtient les dimensions depuis la pile du CPU
	pop de ; On obtient l'adresse de la map depuis la pile du CPU
	ld a, 32
.loop_32
	inc de ; On ajoute 32 à l'adresse de destination (Pour faire un retour à la ligne d'en dessous)
	dec a
	or a ; Si A n'est pas égal à 0, on recommence
	jp nz, .loop_32
	dec c
	cp c ; On vérifie si la map a été complètement dessinée
	jp nz, load_map ; Si elle n'est pas terminée, on retourne à load_map
	ret ; Si c'est fait on peut quitter la routine

check_vram_free:
	push hl
	ld hl, $FF41
	.loop
	bit 1, [hl]
	jr nz, .loop
	pop hl
	ret

; ----- Gestion des palettes GBC -----

; B = Nombre de couleurs
; HL = Pointeur vers la table de la palette
load_pal_bg:
	ld a, $80 ; On commence par écrire sur la première palette et on active l'auto incrément
	ldh [$68], a
.loop
	ld a, [hli]
	ldh [$69], a
	dec b
	jp nz, .loop
	ret
