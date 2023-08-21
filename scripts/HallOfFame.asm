HallOfFame_Script:
	call EnableAutoTextBoxDrawing
	ld hl, HallOfFame_ScriptPointers
	ld a, [wHallOfFameCurScript]
	jp CallFunctionInTable

HallofFameRoomScript_5a4aa:
	xor a
	ld [wJoyIgnore], a
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_ScriptPointers:
	dw HallofFameRoomScript0
	dw HallofFameRoomScript1
	dw HallofFameRoomScript2
	dw HallofFameRoomScript3

HallofFameRoomScript3:
	ret

HallofFameRoomScript2:
	call Delay3
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wJoyIgnore], a
	predef HallOfFamePC
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld hl, wFlags_D733
	res 1, [hl]
	inc hl
	set 0, [hl]
	xor a
	ld hl, wLoreleisRoomCurScript
	ld [hli], a ; wLoreleisRoomCurScript
	ld [hli], a ; wBrunosRoomCurScript
	ld [hl], a ; wAgathasRoomCurScript
	ld [wLancesRoomCurScript], a
	ld [wHallOfFameCurScript], a
	; Elite 4 events
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, INDIGO_PLATEAU_EVENTS_END, 1
	xor a
	ld [wHallOfFameCurScript], a
	ld a, PALLET_TOWN
	ld [wLastBlackoutMap], a
	farcall SaveSAVtoSRAM
	ld b, 5
.delayLoop
	ld c, 600 / 5
	call DelayFrames
	dec b
	jr nz, .delayLoop
	call WaitForTextScrollButtonPress
	jp Init

HallofFameRoomScript0:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEMovement5a528
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wHallOfFameCurScript], a
	ret

RLEMovement5a528:
	db D_UP, 5
	db -1 ; end

HallofFameRoomScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	xor a
	ld [wJoyIgnore], a
	inc a ; PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a

.justTest
	; start of all the hide/show, only the first one (Cerulean Cave Guy) is vanilla
	ld a, HS_CERULEAN_CAVE_GUY
	ld [wMissableObjectIndex], a
	predef HideObject

	ld a, HS_ROUTE_21_OAK 			; new, to show Oak in Route21 after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	ld a, HS_VIRIDIAN_FOREST_ERIKA	; new, to show Erika in Viridian Forest after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	ld a, HS_FIGHTING_DOJO_BRUNO	; new, to show Bruno in Fighting Dojo after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	ld a, HS_ROCK_TUNNEL_B1F_BROCK	; new, to show Brock in Rock Tunnel B1F after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	ld a, HS_POKEMON_TOWER_6F_AGATHA	; new, to show Agatha in Pokemon Tower 6F after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	ld a, HS_VERMILION_MACHOKE		; new, to hide Machoke in Vermilion after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef HideObject				; new

	ld a, HS_VERMILION_MACHAMP		; new, to show Machamp in Vermilion after becoming champion
	ld [wMissableObjectIndex], a	; new
	predef ShowObject				; new

	SetEvent EVENT_BEAT_LEAGUE_AT_LEAST_ONCE ; new
	CheckEvent EVENT_BEAT_LEAGUE_AT_LEAST_ONCE ; temp
	jr z, .continue ; temp
	ld a, $25 ; temp
.continue ; temp

	; vanilla code
	ld a, $2
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_TextPointers:
	dw HallofFameRoomText1

HallofFameRoomText1:
	text_far _HallofFameRoomText1
	text_end
