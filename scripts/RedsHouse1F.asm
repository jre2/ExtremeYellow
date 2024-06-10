RedsHouse1F_Script: ; edited
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse1F_ScriptPointers
	ld a, [wRedsHouse1FCurScript]
	call CallFunctionInTable
	ret

RedsHouse1F_ScriptPointers: ; new
	dw RedsHouse1FScript0
;	dw RedsHouse1FScript1_MomRunningShoes

RedsHouse1FScript0:
	CheckEvent EVENT_MOM_TOLD_US_ABOUT_RUNNING_SHOES
	ret nz
; if we have not been told already, check if we are near the door
	ld a, [wYCoord]
	cp 7
	ret nz
	ld a, [wXCoord]
	cp 2
	jr z, .inFrontOfDoor
	cp 3
	ret nz
.inFrontOfDoor
; player faces mom
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
; mom faces player (both because who knows which and if will work)
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
; other facing because yes
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite01StateData1FacingDirection], a
; actual dialogue
	ld a, 4
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
; boring technical stuff
	SetEvent EVENT_MOM_TOLD_US_ABOUT_RUNNING_SHOES
	ret

RedsHouse1F_TextPointers:
	dw RedsHouse1FMomText
	dw RedsHouse1FTVText
	dw RedsHouse1FPictureText ; new
	dw RedsHouse1FMomRunningShoes ; new

RedsHouse1FMomText:
	text_asm
	callfar Func_f1b73
	jp TextScriptEnd

RedsHouse1FTVText:
	text_asm
	callfar Func_f1bc4
	jp TextScriptEnd

RedsHouse1FPictureText: ; new
	text_far _RedsHouse1FPictureText
	text_end

RedsHouse1FMomRunningShoes: ; new
	text_far _RedsHouse1FMomRunningShoes
	text_end
