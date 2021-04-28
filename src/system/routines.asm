; ----- Gestion de la mémoire -----

; DE = Compteur d'itération
; HL = Adresse mémoire
clear_mem:
	xor a ; A = 0
	ld [hli], a ; On efface le premier octet et on incrémente
	dec de ; On décremente DE
	ld a, d
	or e ; On vérifie si DE est égal à 0
	jp nz, clear_mem ; S'il n'est pas égal à zéro, on retourne au label "clear_mem"
	ret

; BC = Compteur (Nombre d'octets à copier)
; DE = Adresse de destination
; HL = Adresse qui pointe vers les octets à copier
copy_mem:
	ld a, [hli] ; On met le premier octet dans A et on incrémente HL
	ld [de], a ; On copie A dans l'adresse de destination
	inc de ; On incrémente l'adresse de destination
	dec bc ; On décremente le compteur
	ld a, b
	or c ; On vérifie si BC est égal à 0
	jp nz, copy_mem ; Si ce n'est pas le cas on retourne au label "copy_mem"
	ret

; HL = Adresse de destination de la map
; DE = Label vers la chaîne de caractère
display_text:
	ld a, [de]
	ld [hli], a
	inc de
	and a
	jp nz, display_text
	ret