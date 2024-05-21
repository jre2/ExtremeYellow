	db DEX_BLUESMOM ; pokedex id

	db 255,   1, 150, 255, 150
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 1 ; catch rate
	db 1 ; base exp

	INCBIN "gfx/pokemon/front/bluesmom.pic", 0, 1 ; sprite dimensions
	dw BluesMomPicFront, BluesMomPicBack

	db SCRATCH, STOMP, LOW_KICK, CUT ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db BANK(BluesMomPicFront)
	assert BANK(BluesMomPicFront) == BANK(BluesMomPicBack)
