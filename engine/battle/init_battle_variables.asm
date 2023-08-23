InitBattleVariables:
	ldh a, [hTileAnimations]
	ld [wSavedTileAnimations], a
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld [wBattleResult], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wListScrollOffset], a
	ld [wCriticalHitOrOHKO], a
	ld [wBattleMonSpecies], a
	ld [wPartyGainExpFlags], a
	ld [wPlayerMonNumber], a
	ld [wEscapedFromBattle], a
	ld [wMapPalOffset], a
	ld hl, wPlayerHPBarColor
	ld [hli], a ; wPlayerHPBarColor
	ld [hl], a ; wEnemyHPBarColor
	ld hl, wCanEvolveFlags
	ld b, $3c
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	inc a ; POUND
	ld [wTestBattlePlayerSelectedMove], a
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	jr c, .notSafariBattle
	cp SAFARI_ZONE_CENTER_REST_HOUSE
	jr nc, .notSafariBattle

; new special code for Safari Giovanni
	cp SAFARI_ZONE_NORTH
	jr nz, .yesSafariBattle
	; are we around Giovanni?
	ld hl, CoordsData_SafariGiovanni
	call ArePlayerCoordsInArray
	jr c, .notSafariBattle ; if yes, don't load the safari battle
.yesSafariBattle

	ld a, BATTLE_TYPE_SAFARI
	ld [wBattleType], a
.notSafariBattle
	jpfar PlayBattleMusic

CoordsData_SafariGiovanni: ; new
	dbmapcoord 25, 14
	dbmapcoord 25, 15
	dbmapcoord 25, 16
	dbmapcoord 26, 14
	dbmapcoord 26, 16
	dbmapcoord 27, 14
	dbmapcoord 27, 15
	dbmapcoord 27, 16
	db -1 ; end
