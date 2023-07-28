; Yellow entry format:
;	db trainerclass, trainerid
;	repeat { db partymon location, partymon move, move id }
;	db 0

SpecialTrainerMoves:
	db BUG_CATCHER, 15 ; updated
;	db 1, 1, TACKLE
	db 1, 2, BIND
	db 0

	db YOUNGSTER, 14
;	db 6, 1, SLASH
	db 6, 2, DIG
	db 6, 3, DEFENSE_CURL
	db 6, 4, FISSURE
	db 0

	db JUGGLER, 4 ; evil exploding Juggler in Fuchsia Gym :')
	; WEEZING
	db 1, 1, EXPLOSION
	db 1, 2, NO_MOVE
	db 1, 3, NO_MOVE
	db 1, 4, NO_MOVE
	; ELECTRODE
	db 2, 1, EXPLOSION
	db 2, 2, NO_MOVE
	db 2, 3, NO_MOVE
	db 2, 4, NO_MOVE
	; GOLEM
	db 3, 1, EXPLOSION
	db 3, 2, NO_MOVE
	db 3, 3, NO_MOVE
	db 3, 4, NO_MOVE
	; CLOYSTER
	db 4, 1, EXPLOSION
	db 4, 2, NO_MOVE
	db 4, 3, NO_MOVE
	db 4, 4, NO_MOVE
	; LICKILICKY
	db 5, 1, EXPLOSION
	db 5, 2, NO_MOVE
	db 5, 3, NO_MOVE
	db 5, 4, NO_MOVE
	; SNORLAX
	db 6, 1, SELFDESTRUCT
	db 6, 2, NO_MOVE
	db 6, 3, NO_MOVE
	db 6, 4, NO_MOVE
	db 0

	db COOLTRAINER_M, 5 ; pseudo-Red
	; POLIWRATH
	db 1, 1, CLOSE_COMBAT
	db 1, 2, SCALD
	db 1, 3, ICE_BEAM
	db 1, 4, HYPNOSIS
	; VENUSAUR
	db 2, 1, SLUDGE_WAVE
	db 2, 2, FRENZY_PLANT
	db 2, 3, SLEEP_POWDER
	db 2, 4, LEECH_SEED
	; PIKACHU
	db 3, 1, TOXIC
	db 3, 2, IRON_TAIL
	db 3, 3, SURF
	db 3, 4, VOLT_TACKLE
	; SNORLAX
	db 4, 1, AMNESIA
	db 4, 2, CRUNCH
	db 4, 3, REST
	db 4, 4, BODY_SLAM
	; GYARADOS
	db 5, 1, HYDRO_PUMP
	db 5, 2, HYPER_BEAM
	db 5, 3, DRAGON_DANCE
	db 5, 4, CRUNCH
	; AERODACTYL
	db 6, 1, FLY
	db 6, 2, HEAD_SMASH
	db 6, 3, DRAGON_CLAW
	db 6, 4, HYPER_BEAM
	db 0

	db COOLTRAINER_M, 11 ; pseudo-Blue
	; SCIZOR
	db 1, 1, SLASH
	db 1, 2, STEEL_WING
	db 1, 3, X_SCISSOR
	db 1, 4, ROOST
	; CHARIZARD
	db 2, 1, BLAST_BURN
	db 2, 2, FLY
	db 2, 3, REFLECT
	db 2, 4, FIRE_SPIN
	; GOLDUCK
	db 3, 1, HYDRO_PUMP
	db 3, 2, CONFUSION
	db 3, 3, DIG
	db 3, 4, IRON_TAIL
	; MACHAMP
	db 4, 1, KARATE_CHOP
	db 4, 2, HYPER_BEAM
	db 4, 3, FOCUS_ENERGY
	db 4, 4, EARTHQUAKE
	; PORYGON2
	db 5, 1, TRI_ATTACK
	db 5, 2, CONVERSION
	db 5, 3, ZAP_CANNON
	db 5, 4, PSYBEAM
	; RHYPERIOR
	db 6, 1, EARTHQUAKE
	db 6, 2, HEAD_SMASH
	db 6, 3, MEGAHORN
	db 6, 4, HORN_DRILL
	db 0

	db COOLTRAINER_M, 12 ; Cerulean Gym, new
	; KRABBY
	db 4, 1, METAL_CLAW
	db 4, 4, CRABHAMMER
	db 0

	db COOLTRAINER_M, 14 ; Saffron Gym, new
	; JYNX
	db 1, 1, PSYCHIC_M
;	db 1, 2, LOVELY_KISS
	db 1, 3, BLIZZARD
	db 1, 4, DRAININGKISS
	db 0

	db COOLTRAINER_M, 13 ; Celadon Gym, new
	; EXEGGUTOR
	db 5, 1, SLEEP_POWDER
	db 5, 2, PSYCHIC_M
	db 5, 3, EXPLOSION
	db 5, 4, ENERGY_BALL
	db 0

	db COOLTRAINER_F, 5 ; pseudo-Green
	; JIGGLYPUFF
	db 1, 1, SING
	db 1, 2, DISABLE
	db 1, 3, DOUBLE_EDGE
	db 1, 4, DEFENSE_CURL
	; ALAKAZAM
;	db 2, 1, THUNDERPUNCH
;	db 2, 2, ICE_PUNCH
;	db 2, 3, FIRE_PUNCH
	db 2, 4, PSYCHIC_M
	; DITTO
	; lol
	; CLEFABLE
	db 1, 1, MOONBLAST
	db 1, 2, LIGHT_SCREEN
	db 1, 3, REFLECT
	db 1, 4, METRONOME
	; NIDOQUEEN
;	db 5, 1, CRUNCH
	db 5, 2, DOUBLE_KICK
;	db 5, 3, ROCK_TOMB
;	db 5, 4, SLUDGE_WAVE
	; BLASTOISE
	db 6, 1, HYDRO_CANNON
	db 6, 2, FLASH_CANNON
	db 6, 3, ICE_BEAM
	db 6, 4, EARTHQUAKE
	db 0

	db COOLTRAINER_F, 10 ; Cerulean Gym, new
	; PICHU
	db 1, 1, VOLT_TACKLE
	db 1, 2, FLY
	db 1, 3, SURF
	db 1, 4, PSYCHIC_M
	; ELEKID
;	db 2, 1, IRON_TAIL
;	db 2, 2, THUNDERBOLT
;	db 2, 3, KARATE_CHOP
	db 2, 4, CLOSE_COMBAT
	db 0

	db BROCK, 1
	; GEODUDE
;	db 1, 1, TACKLE
;	db 1, 2, DEFENSE_CURL
;	db 1, 3, MUD_SLAP
	db 1, 4, ROCK_THROW
	; OMANYTE
;	db 2, 1, WATER_GUN
;	db 2, 2, DEFENSE_CURL
;	db 2, 3, BIND
;	db 2, 4, SAND_ATTACK
	; KABUTO
;	db 3, 1, SCRATCH
;	db 3, 2, HARDEN
;	db 3, 3, WATER_GUN
	db 3, 4, ABSORB
	; RHYHORN
;	db 4, 1, HORN_ATTACK
	db 4, 2, BIDE
;	db 4, 3, MUD_SLAP
;	db 4, 4, LEER
	; VULPIX
;	db 5, 1, EMBER
;	db 5, 2, LEER
;	db 5, 3, DISABLE
;	db 5, 4, QUICK_ATTACK
	; ONIX
	db 6, 1, BIND
;	db 6, 2, SCREECH
	db 6, 3, BIDE
;	db 6, 4, MUD_SLAP
	db 0

	db MISTY, 1
	; STARYU
;	db 1, 1, CONFUSE_RAY
	db 1, 2, BUBBLEBEAM
;	db 1, 3, MINIMIZE
;	db 1, 4, SWIFT
	; PSYDUCK
	db 2, 1, AMNESIA
;	db 2, 2, DISABLE
;	db 2, 3, ZEN_HEADBUTT
	db 2, 4, HEADBUTT
	; POLIWHIRL
;	db 3, 1, MUD_SHOT
;	db 3, 2, HYPNOSIS
	db 3, 3, LOW_KICK
;	db 3, 4, BUBBLEBEAM
	; GYARADOS
	db 4, 1, BITE
;	db 4, 2, TWISTER
	db 4, 3, BUBBLEBEAM
;	db 4, 4, LEER
	; VAPOREON
	db 5, 1, ACID_ARMOR
	db 5, 2, REST ; AMNESIA?
	db 5, 3, WATER_PULSE
	db 5, 4, AURORA_BEAM
	; STARMIE
	db 6, 1, RECOVER
	db 6, 2, BUBBLEBEAM
;	db 6, 3, MINIMIZE
	db 6, 4, PSYBEAM
	db 0

	db LT_SURGE, 1
	; PIKACHU
	db 1, 1, FLY
	db 1, 2, SURF
;	db 1, 3, SING
	db 1, 4, VOLT_TACKLE
	; VOLTORB
;	db 2, 1, SONICBOOM
	db 2, 2, THUNDER_WAVE
;	db 2, 3, SELFDESTRUCT
;	db 2, 4, SHOCK_WAVE
	; MAGNEMITE
;	db 3, 1, SONICBOOM
	db 3, 2, FLASH_CANNON
	db 3, 3, SUPERSONIC
;	db 3, 4, SHOCK_WAVE
	; ELECTABUZZ
;	db 4, 1, THUNDER_WAVE
;	db 4, 2, BARRIER
	db 4, 3, THUNDERPUNCH
	db 4, 4, SEISMIC_TOSS
	; JOLTEON
;	db 5, 1, THUNDERBOLT
;	db 5, 2, THUNDER_WAVE
	db 5, 3, DIG
	db 5, 4, BITE
	; RAICHU
	db 6, 1, ZAP_CANNON
	db 6, 2, MEGA_PUNCH
	db 6, 3, IRON_TAIL
	db 6, 4, SUBMISSION
	db 0

	db ERIKA, 1
	; PARASECT
;	db 1, 1, SPORE
	db 1, 2, INFESTATION
	db 1, 3, GIGA_DRAIN
;	db 1, 4, SLASH
	; VILEPLUME
	db 2, 1, STUN_SPORE
	db 2, 2, MOONBLAST
	db 2, 3, GUNK_SHOT
	db 2, 4, PETAL_DANCE
	; BELLOSSOM
	db 3, 1, STUN_SPORE
	db 3, 2, MOONBLAST
	db 3, 3, DRAIN_PUNCH
	db 3, 4, PETAL_DANCE
	; VICTREEBEL
	db 4, 1, WRAP
	db 4, 2, HYPER_BEAM
	db 4, 3, SLEEP_POWDER
	db 4, 4, RAZOR_LEAF
	; LEAFEON
	db 5, 1, SWORDS_DANCE
	db 5, 2, HYPER_BEAM
	db 5, 3, SAND_ATTACK
	db 5, 4, LEAF_STORM
	; TANGROWTH
	db 6, 1, LIGHT_SCREEN
	db 6, 2, REFLECT
	db 6, 3, LEECH_SEED
	db 6, 4, ROCK_SLIDE
	db 0

	db KOGA, 1
	; MUK
	db 1, 1, TOXIC
	db 1, 2, MINIMIZE
	db 1, 3, DIG ; FIRE_BLAST?
;	db 1, 4, GUNK_SHOT
	; BEEDRILL
	db 2, 1, SWORDS_DANCE
	db 2, 2, X_SCISSOR
	db 2, 3, ROOST
;	db 2, 4, SLUDGE_WAVE
	; VENOMOTH
	db 3, 1, STUN_SPORE
	db 3, 2, SLEEP_POWDER
	db 3, 3, LEECH_LIFE
	db 3, 4, PSYCHIC_M
	; TENTACRUEL
	db 4, 1, TOXIC ; ACID_ARMOR? (default)
	db 4, 2, ICE_BEAM
;	db 4, 3, SURF
;	db 4, 4, SLUDGE_WAVE
	; CROBAT
	db 5, 1, CONFUSE_RAY
	db 5, 2, SUPER_FANG
	db 5, 3, DOUBLE_TEAM
	db 5, 4, LEECH_LIFE ; ROOST?
	; WEEZING
;	db 6, 1, SLUDGE_WAVE
	db 6, 2, SMOKESCREEN
;	db 6, 3, FLAMETHROWER
;	db 6, 4, EXPLOSION
	db 0

	db BLAINE, 1
	; NINETALES
	db 1, 1, CONFUSE_RAY
;	db 1, 2, ENERGY_BALL
	db 1, 3, HYPNOSIS
	db 1, 4, FIRE_BLAST
	; RAPIDASH
	db 2, 1, WILL_O_WISP
	db 2, 2, FIRE_SPIN
;	db 2, 3, MEGAHORN
	db 2, 4, FLARE_BLITZ
	; MAGMORTAR
	db 3, 1, THUNDERBOLT
	db 3, 2, MACH_PUNCH
;	db 3, 3, FLAMETHROWER
	db 3, 4, SOLARBEAM
	; FLAREON
	db 4, 1, IRON_TAIL
;	db 4, 2, FLAMETHROWER
;	db 4, 3, SUPERPOWER
	db 4, 4, SHADOW_BALL
	; RHYDON
;	db 5, 1, STONE_EDGE ; HEAD_SMASH?
	db 5, 2, MEGAHORN
	db 5, 3, EARTHQUAKE
	db 5, 4, SUPERPOWER
	; ARCANINE
	db 6, 1, EXTREMESPEED
	db 6, 2, FLARE_BLITZ
	db 6, 3, CLOSE_COMBAT
	db 6, 4, HYPER_BEAM
	db 0

	db SABRINA, 1
	; EXEGGUTOR
;	db 1, 1, GIGA_DRAIN
	db 1, 2, PSYCHIC_M
	db 1, 3, SLEEP_POWDER
	db 1, 4, EXPLOSION
	; SLOWKING
;	db 2, 1, FLAMETHROWER
	db 2, 2, PSYCHIC_M
;	db 2, 3, SCALD
;	db 2, 4, DRAIN_PUNCH
	; MR_MIME
	db 3, 1, BARRIER ; SUBSTITUTE?
	db 3, 2, PLAY_ROUGH
	db 3, 3, MIMIC
	db 3, 4, METRONOME ; PSYCHIC_M?
	; ESPEON
	db 4, 1, ZAP_CANNON
;	db 4, 2, PSYCHIC_M
	db 4, 3, BITE
	db 4, 4, FOCUS_ENERGY ; HYPER_BEAM?
	; HAUNTER
	db 5, 1, ICE_PUNCH
	db 5, 2, SHADOW_CLAW
;	db 5, 3, DARK_PULSE
	db 5, 4, CONFUSE_RAY
	; ALAKAZAM
;	db 6, 1, THUNDERPUNCH
;	db 6, 2, ICE_PUNCH
;	db 6, 3, FIRE_PUNCH
	db 6, 4, PSYCHIC_M
	db 0

	db GIOVANNI, 1
	; ONIX
;	db 1, 1, ROCK_SLIDE
	db 1, 2, DIG
	db 1, 3, BIND
	db 1, 4, TWISTER
	; RHYHORN
;	db 2, 1, FURY_ATTACK
	db 2, 2, ROCK_TOMB
	db 2, 3, MUD_SLAP
;	db 2, 4, IRON_TAIL
	; DUGTRIO
;	db 3, 1, DIG
	db 3, 2, SLASH
;	db 3, 3, SCREECH
;	db 3, 4, SAND_ATTACK
	; KANGASKHAN
	db 4, 1, THUNDERBOLT
	db 4, 2, AERIAL_ACE
	db 4, 3, DRAIN_PUNCH
	db 4, 4, DIZZY_PUNCH
	; MAROWAK
	db 5, 1, FURY_ATTACK
	db 5, 2, WATER_GUN
	db 5, 3, ROCK_TOMB
	db 5, 4, BONEMERANG
	; PERSIAN
	db 6, 1, SHADOW_BALL
	db 6, 2, BUBBLEBEAM
	db 6, 3, PAY_DAY
	db 6, 4, SLASH
	db 0

	db GIOVANNI, 2
	; STEELIX
	db 1, 1, IRON_TAIL
	db 1, 2, EARTHQUAKE
	db 1, 3, DRAGONBREATH
;	db 1, 4, HEADBUTT
	; NIDOKING
;	db 2, 1, ICE_PUNCH
	db 2, 2, EARTHQUAKE
;	db 2, 3, THRASH
;	db 2, 4, TOXIC
	; RHYDON
	db 3, 1, BODY_SLAM
	db 3, 2, STONE_EDGE
;	db 3, 3, EARTHQUAKE
;	db 3, 4, IRON_TAIL
	; NIDOQUEEN
	db 4, 1, THUNDERBOLT
	db 4, 2, ICE_BEAM
	db 4, 3, LOVELY_KISS
	db 4, 4, SUPER_FANG
	; GOLEM
	db 5, 1, SELFDESTRUCT
;	db 5, 2, EARTHQUAKE
;	db 5, 3, ROCK_TOMB
	db 5, 4, SEISMIC_TOSS
	; PERSIAN
	db 6, 1, SLASH
;	db 6, 2, PAY_DAY
	db 6, 3, DREAM_EATER
	db 6, 4, HYPNOSIS
	db 0

	db GIOVANNI, 3
	; DUGTRIO
;	db 1, 1, EARTHQUAKE
	db 1, 2, SLUDGE_WAVE
	db 1, 3, FISSURE
	db 1, 4, STONE_EDGE
	; GOLEM
	db 2, 1, SUPERPOWER
;	db 2, 2, EXPLOSION
	db 2, 3, EARTHQUAKE
;	db 2, 4, STONE_EDGE
	; NIDOQUEEN
	db 3, 1, THUNDER
	db 3, 2, BLIZZARD
	db 3, 3, LOVELY_KISS
	db 3, 4, SUPER_FANG
	; NIDOKING
;	db 4, 1, MEGAHORN
	db 4, 2, OUTRAGE
	db 4, 3, EARTHQUAKE
	db 4, 4, GUNK_SHOT
	; RHYPERIOR
	db 5, 1, HEAD_SMASH
	db 5, 2, MEGAHORN
	db 5, 3, EARTHQUAKE
	db 5, 4, FLASH_CANNON
	; PERSIAN
	db 6, 1, HYPNOSIS ; SLASH?
	db 6, 2, AERIAL_ACE ; HYPER_BEAM?
	db 6, 3, SHADOW_CLAW ; THUNDERBOLT?
	db 6, 4, SLASH ; TOXIC? PAY_DAY?
	db 0

	db LORELEI, 1
	; DEWGONG
	db 1, 1, AQUA_JET
	db 1, 2, REST
	db 1, 3, WATERFALL
	db 1, 4, BLIZZARD
	; CLOYSTER
	db 2, 1, EXPLOSION
;	db 2, 2, PIN_MISSILE
;	db 2, 3, SPIKE_CANNON ; HYDRO_PUMP?
;	db 2, 4, ICICLE_SPEAR
	; JYNX
	db 3, 1, BLIZZARD
	db 3, 2, LOVELY_KISS
	db 3, 3, DRAININGKISS
;	db 3, 4, PSYCHO_CUT
	; GLACEON
	db 4, 1, BLIZZARD
;	db 4, 2, MIRROR_COAT
	db 4, 3, WATER_PULSE
	db 4, 4, BARRIER
	; LAPRAS
	db 5, 1, PSYCHIC_M
	db 5, 2, BLIZZARD
	db 5, 3, HYDRO_PUMP
	db 5, 4, REST
	; MSLOWBRO
	db 6, 1, AMNESIA
	db 6, 2, PSYCHIC_M
	db 6, 3, REST
;	db 6, 4, SCALD ; THUNDER_WAVE?
	db 0

	db BRUNO, 1
	; HITMONTOP
;	db 1, 1, FOCUS_ENERGY
	db 1, 2, STONE_EDGE
	db 1, 3, EARTHQUAKE
;	db 1, 3, HI_JUMP_KICK
	; HITMONCHAN
	db 2, 1, DRAIN_PUNCH
	db 2, 2, SHADOW_PUNCH
	db 2, 3, DIZZY_PUNCH
;	db 2, 4, BULLET_PUNCH
	; HITMONLEE
;	db 3, 1, HI_JUMP_KICK
	db 3, 2, CLOSE_COMBAT
	db 3, 3, ROLLING_KICK
	db 3, 4, STONE_EDGE
	; POLIWRATH
	db 4, 1, ROCK_SLIDE
	db 4, 2, CLOSE_COMBAT
	db 4, 3, SCALD
;	db 4, 4, LOVELY_KISS
	; MACHAMP
 	db 5, 1, STONE_EDGE
	db 5, 2, FISSURE
	db 5, 3, CLOSE_COMBAT
;	db 5, 4, DRAIN_PUNCH
	; MSTEELIX
 	db 6, 1, METEOR_MASH
	db 6, 2, EARTHQUAKE
	db 6, 3, EXPLOSION
;	db 6, 4, DRAGON_DANCE
	db 0

	db AGATHA, 1
	; GENGAR 1
	db 1, 1, THUNDER_WAVE
	db 1, 2, CONFUSE_RAY
	db 1, 3, MINIMIZE
	db 1, 4, DARK_PULSE
	; CROBAT
	db 2, 1, AIR_SLASH
;	db 2, 2, ROOST
;	db 2, 3, GUNK_SHOT
	db 2, 4, LEECH_LIFE
	; GENGAR 2
	db 3, 1, PSYCHIC_M
	db 3, 2, NIGHT_SLASH
	db 3, 3, WILL_O_WISP ; THUNDERBOLT?
	db 3, 4, GIGA_DRAIN
	; ANNIHILAPE
	db 4, 1, CLOSE_COMBAT
	db 4, 2, SHADOW_PUNCH
	db 4, 3, STONE_EDGE
	db 4, 4, GUNK_SHOT
	; UMBREON
	db 5, 1, REST
;	db 5, 2, DARK_PULSE
	db 5, 3, DOUBLE_TEAM
	db 5, 4, TOXIC
	; MGENGAR
	db 6, 1, DRAININGKISS
	db 6, 2, NIGHT_SLASH
	db 6, 3, THUNDERBOLT
	db 6, 4, ENERGY_BALL
	db 0

	db LANCE, 1
	; GYARADOS
	db 1, 1, HURRICANE
	db 1, 2, FIRE_BLAST ; DRAGON_DANCE?
	db 1, 3, OUTRAGE ; STONE_EDGE?
;	db 1, 4, HYPER_BEAM ; EARTHQUAKE?
	; DRAGONITE 1
	db 2, 1, DRAGON_DANCE
	db 2, 2, AIR_SLASH
	db 2, 3, STEEL_WING
	db 2, 4, EARTHQUAKE
	; AERODACTYL
;	db 3, 1, AIR_CUTTER
	db 3, 2, HEAD_SMASH
	db 3, 3, EARTHQUAKE
;	db 3, 4, HYPER_BEAM
	; KINGDRA
	db 4, 1, FLASH_CANNON
	db 4, 2, OUTRAGE
	db 4, 3, HYPER_BEAM
;	db 4, 4, HYDRO_PUMP
	; DRAGONITE 2
	db 5, 1, ROOST
	db 5, 2, THUNDER_WAVE
	db 5, 3, WRAP
	db 5, 4, OUTRAGE
	; MCHARZARDX
	db 6, 1, HYPER_BEAM
;	db 6, 2, SHADOW_CLAW
;	db 6, 3, DRAGON_DANCE
	db 6, 4, STEEL_WING
	db 0

	db RIVAL1, 3
	; PIDGEOTTO
	db 1, 1, SAND_ATTACK ; old move
;	db 1, 2, QUICK_ATTACK
;	db 1, 3, TWISTER
;	db 1, 4, WING_ATTACK
	; NIDOKING
;	db 2, 1, DOUBLE_KICK
	db 2, 2, MEGA_PUNCH ; TM!
	db 2, 3, BUBBLEBEAM ; TM!
;	db 2, 4, MUD_SLAP
	; CLEFABLE
;	db 3, 1, SING
	db 3, 2, MINIMIZE ; old move
;	db 3, 3, MUD_SLAP
	db 3, 4, METRONOME ; old move
	; SANDSHREW
;	db 4, 1, SAND_ATTACK
;	db 4, 2, DEFENSE_CURL
;	db 4, 3, MUD_SLAP
;	db 4, 4, SLASH
	; MANKEY
	db 5, 1, METRONOME ; TM!
;	db 5, 2, MUD_SLAP
;	db 5, 3, SEISMIC_TOSS
;	db 5, 4, KARATE_CHOP
	; EEVEE
;	db 6, 1, SAND_ATTACK
;	db 6, 2, QUICK_ATTACK
	db 6, 3, BIDE ; TM!
;	db 6, 4, MUD_SLAP
	db 0

	db RIVAL2, 1
	; NIDOKING
	db 1, 1, DOUBLE_KICK
	db 1, 2, DIG
	db 1, 3, BUBBLEBEAM
;	db 1, 4, BODY_SLAM
	; PIDGEOTTO
	db 2, 1, SAND_ATTACK
;	db 2, 2, QUICK_ATTACK
;	db 2, 3, TWISTER
;	db 2, 4, WING_ATTACK
	; CLEFABLE
	db 3, 1, SING
;	db 3, 2, MUD_SLAP
	db 3, 3, MINIMIZE
	db 3, 4, METRONOME
	; SANDSLASH
;	db 4, 1, DEFENSE_CURL
;	db 4, 2, MUD_SLAP
;	db 4, 3, SLASH
	db 4, 4, SAND_ATTACK
	; RATICATE
	db 5, 1, BUBBLEBEAM
;	db 5, 2, HYPER_FANG
	db 5, 3, FOCUS_ENERGY
;	db 5, 4, SUPER_FANG
	; EEVEE
;	db 6, 1, SAND_ATTACK
;	db 6, 2, QUICK_ATTACK
	db 6, 3, BIDE
	db 6, 4, BITE
	db 0

	db RIVAL2, 2
	; PINSIR
;	db 1, 1, SEISMIC_TOSS
	db 1, 2, X_SCISSOR
	db 1, 3, ROCK_SLIDE
	db 1, 4, SWORDS_DANCE ; DIG?
	; PORYGONZ
	db 2, 1, AMNESIA
	db 2, 2, TRI_ATTACK
	db 2, 3, DARK_PULSE
	db 2, 4, PSYCHIC_M
	; KLEAVOR
	db 3, 1, X_SCISSOR
;	db 3, 2, AIR_SLASH
	db 3, 3, STONE_EDGE
;	db 3, 4, SWORDS_DANCE
	; CLOYSTER
	db 4, 1, LIGHT_SCREEN
;	db 4, 2, CLAMP
;	db 4, 3, AURORA_BEAM
;	db 4, 4, MUD_SHOT
	; NINETALES
	db 5, 1, FIRE_SPIN
;	db 5, 2, CONFUSE_RAY
;	db 5, 4, WILL_O_WISP
;	db 5, 4, HYPNOSIS
	; UMBREON
	db 6, 1, DARK_PULSE
	db 6, 2, DOUBLE_TEAM
;	db 6, 3, CONFUSE_RAY
	db 6, 4, REST
	db 0

	db RIVAL2, 3
	; ANNIHILAPE
	db 1, 1, CLOSE_COMBAT ; DRAIN_PUNCH?
	db 1, 2, SHADOW_CLAW
	db 1, 3, STONE_EDGE
	db 1, 4, GUNK_SHOT ; COUNTER?
	; ALAKAZAM
;	db 2, 1, REFLECT
	db 2, 2, THUNDER_WAVE
	db 2, 3, PSYCHO_CUT
	db 2, 4, RECOVER
	; ELECTIVIRE
;	db 3, 1, ICE_PUNCH
;	db 3, 2, ROCK_TOMB
	db 3, 3, THUNDERPUNCH
	db 3, 4, KARATE_CHOP
	; JYNX
	db 4, 1, ICE_BEAM
	db 4, 2, DRAININGKISS
;	db 4, 3, LOVELY_KISS
;	db 4, 4, DREAM_EATER
	; MAGMORTAR
	db 5, 1, ROCK_SLIDE
	db 5, 2, FIRE_BLAST
;	db 5, 3, KARATE_CHOP
	db 5, 4, BULLET_SEED
	; UMBREON
	db 6, 1, TOXIC
	db 6, 2, DOUBLE_TEAM
	db 6, 3, REST
;	db 6, 4, DARK_PULSE
	db 0

	db RIVAL2, 4
	; JOLTEON
	db 1, 1, DOUBLE_KICK
	db 1, 2, THUNDER_WAVE
	db 1, 3, BITE
;	db 1, 4, ZAP_CANNON
	; VAPOREON
	db 2, 1, TOXIC
	db 2, 2, REST
;	db 2, 3, ACID_ARMOR
	db 2, 4, SCALD
	; FLAREON
;	db 3, 1, IRON_TAIL
	db 3, 2, WILL_O_WISP
;	db 3, 3, SUPERPOWER
;	db 3, 4, HEAT_WAVE
	; LEAFEON
	db 4, 1, BODY_SLAM
	db 4, 2, LEECH_SEED
;	db 4, 3, AERIAL_ACE
	db 4, 4, LEAF_STORM
	; GLACEON
	db 5, 1, SAND_ATTACK
	db 5, 2, REST
	db 5, 3, BLIZZARD
	db 5, 4, SUBSTITUTE
	; UMBREON
	db 6, 1, CONFUSE_RAY
;	db 6, 2, DARK_PULSE
	db 6, 3, REST
	db 6, 4, DOUBLE_TEAM
	db 0

	db RIVAL3, 1
	; MPIDGEOT
	db 1, 1, THUNDER
	db 1, 2, BLIZZARD
	db 1, 3, HEAT_WAVE
;	db 1, 4, HURRICANE
	; MALAKAZAM
;	db 2, 1, PSYCHIC_M
	db 2, 2, DARK_PULSE
	db 2, 3, MOONBLAST
;	db 2, 4, ZAP_CANNON
	; MSCIZOR
	db 3, 1, METEOR_MASH
;	db 3, 2, STEEL_WING
	db 3, 3, LEECH_LIFE
	db 3, 4, CLOSE_COMBAT
	; MVENUSAUR
	db 4, 1, DOUBLE_EDGE
;	db 4, 2, GUNK_SHOT
	db 4, 3, EARTHQUAKE
;	db 4, 4, FRENZY_PLANT
	; MCHARZARDY
	db 5, 1, HURRICANE ; ?
	db 5, 2, DRAGON_CLAW
	db 5, 3, CRUNCH
;	db 5, 4, BLAST_BURN
	; MBLASTOISE
	db 6, 1, ZAP_CANNON
	db 6, 2, OUTRAGE
	db 6, 3, BLIZZARD
;	db 6, 4, HYDRO_CANNON
	db 0

	db ROCKET, 42
	; EKANS
	db 1, 1, WRAP
;	db 1, 2, POISON_STING
;	db 1, 3, BITE
;	db 1, 4, GLARE
	; KOFFING
	db 2, 1, TACKLE
;	db 2, 2, SMOG
;	db 2, 3, SMOKESCREEN
;	db 2, 4, INFESTATION
	; MEOWTH
	db 3, 1, SCRATCH
;	db 3, 2, LEER
;	db 3, 3, DEFENSE_CURL
;	db 3, 4, BITE
	db 0

	db ROCKET, 43
	; ARBOK
;	db 1, 1, GLARE
;	db 1, 2, SCREECH
;	db 1, 3, ACID
	db 1, 4, WRAP
	; WEEZING
;	db 2, 1, SMOKESCREEN
;	db 2, 2, HEADBUTT
;	db 2, 3, SLUDGE
;	db 2, 4, INFESTATION
	; MEOWTH
;	db 3, 1, PAY_DAY
;	db 3, 2, MUD_SLAP
;	db 3, 3, SWIFT
;	db 3, 4, HEADBUTT
	db 0

	db ROCKET, 44
	; ARBOK
	db 1, 1, GLARE
;	db 1, 2, CRUNCH
;	db 1, 3, SLUDGE
;	db 1, 4, HEADBUTT
	; LICKITUNG
;	db 2, 1, SLAM
	db 2, 2, LICK
	db 2, 3, WRAP
;	db 2, 4, ROCK_TOMB
	; WEEZING
	db 3, 1, SMOKESCREEN
	db 3, 2, INFESTATION
;	db 3, 3, SELFDESTRUCT
;	db 3, 4, SLUDGE_WAVE
	; WEEPINBELL
	db 4, 1, WRAP
;	db 4, 2, ACID
	db 4, 3, STUN_SPORE
;	db 4, 4, MAGICAL_LEAF
	; MEOWTH
;	db 5, 1, FURY_SWIPES
	db 5, 2, PAY_DAY
;	db 5, 3, CRUNCH
;	db 5, 4, WATER_PULSE
	db 0

	db ROCKET, 45
	; ARBOK
	db 1, 1, DARK_PULSE
	db 1, 2, EARTHQUAKE
	db 1, 3, GIGA_DRAIN
;	db 1, 4, SLUDGE_WAVE
	; LICKILICKY
	db 2, 1, ICE_BEAM
	db 2, 2, THUNDERBOLT
	db 2, 3, FIRE_BLAST
;	db 2, 4, AMNESIA
	; WEEZING
	db 3, 1, SHADOW_BALL
	db 3, 2, EXPLOSION
;	db 3, 3, SLUDGE_WAVE
;	db 3, 4, HEAT_WAVE
	; VICTREEBEL
	db 4, 1, TOXIC
	db 4, 2, GROWTH
	db 4, 3, GIGA_DRAIN
;	db 4, 4, LEECH_LIFE
	; MEOWTH
	db 5, 1, PAY_DAY
;	db 5, 2, SLASH
;	db 5, 3, SING
;	db 5, 4, DREAM_EATER
	db 0

	db PROF_OAK, 1
	; TAUROS
	db 1, 1, HYPER_BEAM
	db 1, 2, BODY_SLAM
	db 1, 3, EARTHQUAKE
	db 1, 4, BLIZZARD
	; MGYARADOS
	db 2, 1, NIGHT_SLASH
	db 2, 2, HYDRO_PUMP
	db 2, 3, HYPER_BEAM
	db 2, 4, EARTHQUAKE
	; MEWTWO
	db 3, 1, AMNESIA
	db 3, 2, PSYCHIC_M
	db 3, 3, RECOVER
	db 3, 4, THUNDERBOLT
	; MMEWTWOX
	db 4, 1, CLOSE_COMBAT
	db 4, 2, STONE_EDGE
	db 4, 3, LEECH_LIFE
	db 4, 4, METEOR_MASH
	; MMEWTWOY
	db 5, 1, BLIZZARD
	db 5, 2, PSYCHO_CUT
	db 5, 3, THUNDER
	db 5, 4, MOONBLAST
	; VENUSTOISE
	db 6, 1, HYDRO_CANNON
	db 6, 2, FRENZY_PLANT
	db 6, 3, GUNK_SHOT
	db 6, 4, ZEN_HEADBUTT
	db 0

	db -1 ; end
