CopycatsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld de, CopycatsHouse2F_ScriptPointers
	ld a, [wCopycatsHouse2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCopycatsHouse2FCurScript], a
	ret

; ===============================

CopycatsHouse2F_ScriptPointers:
	dw CopycatsHouse2FScript0
	dw CopycatsHouse2FScriptPostBattle

CopycatsHouse2FScript0:
	ret

CopycatsHouse2FScriptPostBattle:
	ld a, [wLevelScalingBackup]
	ld [wLevelScaling], a
	xor a
	ld [wCopycatsHouse2FCurScript], a
	ld [wCurMapScript], a
; check battle result
	ld a, [wIsInBattle]
	cp $ff
	jr z, .gotDefeated
; if you won
	SetEvent EVENT_DEFEATED_COPYCAT
	ld a, 1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gotDefeated
	ret

; ===============================

CopycatsHouse2F_TextPointers:
	dw CopycatsHouse2FText1
	dw CopycatsHouse2FText2
	dw CopycatsHouse2FText3
	dw CopycatsHouse2FText4
	dw CopycatsHouse2FText5
	dw CopycatsHouse2FText6
	dw CopycatsHouse2FText7

CopycatsHouse2FText1: ; edited
	text_asm
	CheckEvent EVENT_GOT_TM31
	jr nz, .got_item
	CheckEvent EVENT_DEFEATED_COPYCAT
	jr nz, .defatedCopycatButNotGotTMYet
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CopycatsHouse2FText_5ccd4
	call PrintText
	ld b, POKE_DOLL
	call IsItemInBag
	jr z, .done
	ld hl, TM31PreReceiveText
	call PrintText
; backup the current Level Scaling option choice to restore it after the battle
	ld a, [wLevelScaling]
	ld [wLevelScalingBackup], a
	ld a, 1
	ld [wLevelScaling], a
; set up the battle
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CopycatText_PostBattleText
	ld de, CopycatText_PostBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_PSYCHIC_TR
	ld [wCurOpponent], a
	ld a, 5
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, 1
	ld [wCopycatsHouse2FCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.defatedCopycatButNotGotTMYet
	ld hl, PostBattleAndGiveTMText
	call PrintText
	lb bc, TM_MIMIC, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ReceivedTM31Text
	call PrintText
	SetEvent EVENT_GOT_TM31
	jr .done
.bag_full
	ld hl, TM31NoRoomText
	call PrintText
	jr .done
.got_item
	ld hl, TM31ExplanationText2
	call PrintText
.done
	jp TextScriptEnd

CopycatsHouse2FText_5ccd4:
	text_far _CopycatsHouse2FText_5ccd4
	text_end

TM31PreReceiveText:
	text_far _TM31PreReceiveText
	text_end

ReceivedTM31Text:
	text_far _ReceivedTM31Text
	sound_get_item_1
TM31ExplanationText1:
	text_far _TM31ExplanationText1
;	text_waitbutton
	text_end

TM31ExplanationText2:
	text_far _TM31ExplanationText2
	text_end

TM31NoRoomText:
	text_far _TM31NoRoomText
	text_waitbutton
	text_end

CopycatsHouse2FText2:
	text_far _CopycatsHouse2FText2
	text_end

CopycatsHouse2FText5:
CopycatsHouse2FText4:
CopycatsHouse2FText3:
	text_far _CopycatsHouse2FText3
	text_end

CopycatsHouse2FText6:
	text_far _CopycatsHouse2FText6
	text_end

CopycatsHouse2FText7:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, CopycatsHouse2FText_5cd1c
	jr nz, .notUp
	ld hl, CopycatsHouse2FText_5cd17
.notUp
	call PrintText
	jp TextScriptEnd

CopycatsHouse2FText_5cd17:
	text_far _CopycatsHouse2FText_5cd17
	text_end

CopycatsHouse2FText_5cd1c:
	text_far _CopycatsHouse2FText_5cd1c
	text_end

PostBattleAndGiveTMText: ; new
	text_far _PostBattleAndGiveTMText
	text_end

CopycatText_PostBattleText: ; new
	text_far _CopycatText_PostBattleText
	text_end
