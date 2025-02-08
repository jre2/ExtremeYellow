MACRO move_choices
	IF _NARG
		db \# ; all args
	ENDC
	db 0 ; end
	DEF list_index += 1
ENDM

; 1 discourge non-damage status moves if enemy already statused
; 2 encourge early turn status/buffs
; 3 encourge super effective, exploding if low hp, STAB, prio if slower, swift if slower and invuln
; 4 encourge tactical switching (certain statuses, debuffs, trapped, only discouraged moves, etc)
; move choice modification methods that are applied for each trainer class
TrainerClassMoveChoiceModifications:
	list_start TrainerClassMoveChoiceModifications
	move_choices 1, 2, 3, 4 ; YOUNGSTER
	move_choices 1, 2, 3, 4 ; BUG_CATCHER
	move_choices 1, 2, 3, 4 ; LASS
	move_choices 1, 2, 3, 4 ; SAILOR
;	move_choices 1, 2, 3, 4 ; JR_TRAINER_M ; edited
	move_choices 1, 2, 3, 4 ; JR_TRAINER_F ; edited
	move_choices 1, 2, 3, 4 ; POKEMANIAC ; edited
	move_choices 1, 2, 3, 4 ; SUPER_NERD ; edited
	move_choices 1, 2, 3, 4 ; HIKER ; edited
	move_choices 1, 2, 3, 4 ; BIKER
	move_choices 1, 2, 3, 4 ; BURGLAR ; edited
	move_choices 1, 2, 3, 4 ; ENGINEER ; edited
;	move_choices 1, 2, 3, 4 ; UNUSED_JUGGLER
	move_choices 1, 2, 3, 4 ; FISHER ; edited
	move_choices 1, 2, 3, 4 ; SWIMMER ; edited
	move_choices 1, 2, 3, 4 ; CUE_BALL
	move_choices 1, 2, 3, 4 ; GAMBLER ; edited
	move_choices 1, 2, 3, 4 ; BEAUTY ; edited
	move_choices 1, 2, 3, 4 ; PSYCHIC_TR ; edited
	move_choices 1, 2, 3, 4 ; ROCKER ; edited
	move_choices 1, 2, 3, 4 ; JUGGLER ; edited
	move_choices 1, 2, 3, 4 ; TAMER ; edited
	move_choices 1, 2, 3, 4 ; BIRD_KEEPER ; edited
	move_choices 1, 2, 3, 4 ; BLACKBELT ; edited
	move_choices 1, 2, 3, 4 ; RIVAL1
	move_choices 1, 2, 3, 4 ; PROF_OAK ; edited
;	move_choices 1, 2, 3, 4 ; CHIEF
	move_choices 1, 2, 3, 4 ; SCIENTIST ; edited
	move_choices 1, 2, 3, 4 ; GIOVANNI ; edited
	move_choices 1, 2, 3, 4 ; ROCKET ; edited
;	move_choices 1, 2, 3, 4 ; COOLTRAINER_M
	move_choices 1, 2, 3, 4 ; COOLTRAINER ; edited
	move_choices 1, 2, 3, 4 ; BRUNO ; edited
	move_choices 1, 2, 3, 4 ; BROCK ; edited
	move_choices 1, 2, 3, 4 ; MISTY ; edited
	move_choices 1, 2, 3, 4 ; LT_SURGE ; edited
	move_choices 1, 2, 3, 4 ; ERIKA ; edited
	move_choices 1, 2, 3, 4 ; KOGA ; edited
	move_choices 1, 2, 3, 4 ; BLAINE ; edited
	move_choices 1, 2, 3, 4 ; SABRINA ; edited
	move_choices 1, 2, 3, 4 ; GENTLEMAN ; edited
	move_choices 1, 2, 3, 4 ; RIVAL2 ; edited
	move_choices 1, 2, 3, 4 ; RIVAL3 ; edited
	move_choices 1, 2, 3, 4 ; LORELEI ; edited
	move_choices 1, 2, 3, 4 ; CHANNELER ; edited
	move_choices 1, 2, 3, 4 ; AGATHA ; edited
	move_choices 1, 2, 3, 4 ; LANCE ; edited
; new classes
	move_choices 1, 2, 3, 4 ; ORAGE
	move_choices 1, 2, 3, 4 ; PIGEON
	move_choices 1, 2, 3, 4 ; TRAVELER
	move_choices 1, 2, 3, 4 ; BF_TRAINER
	move_choices 1, 2, 3    ; MISSINGNO_T
	assert_list_length NUM_TRAINERS
