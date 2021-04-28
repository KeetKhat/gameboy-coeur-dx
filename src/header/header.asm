SECTION "Entry point", ROM0[$100]
nop
jp main ; $150

SECTION "Header", ROM0[$104]

REPT $150 - $104
	DB 0 ; Fill the header with 00
ENDR
