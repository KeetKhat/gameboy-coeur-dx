SECTION "Interrupts", ROM0[$40]

SECTION "VBlank", ROM0[$40]
	call vblank
	reti

SECTION "LCD STAT", ROM0[$48]
	reti

SECTION "Timer", ROM0[$50]
	reti

SECTION "Serial", ROM0[$58]
	reti

SECTION "Joypad", ROM0[$60]
	reti