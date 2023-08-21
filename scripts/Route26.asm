Route26_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route26TrainerHeaders
	ld de, Route26_ScriptPointers
	ld a, [wRoute26CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute26CurScript], a
	ret

Route26_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route26_TextPointers:
	dw Route26Text1
	dw BoulderText
	dw Route26Text2 ; sign welcome
	dw Route26Text3 ; sign burrowing

Route26TrainerHeaders:
	def_trainers
Route26TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_26_TRAINER_0, 1, Route26BattleText1, Route26EndBattleText1, Route26AfterBattleText1
	db -1 ; end

; --- non-trainers ---

; --- trainers ---

Route26Text1:
	text_asm
	ld hl, Route26TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route26BattleText1:
	text_far _Route26BattleText1
	text_end

Route26EndBattleText1:
	text_far _Route26EndBattleText1
	text_end

Route26AfterBattleText1:
	text_far _Route26AfterBattleText1
	text_end

; --- signs ---

Route26Text2:
	text_far _Route26Text2
	text_end

Route26Text3:
	text_far _Route26Text3
	text_end
