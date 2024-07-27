CreditsOrder:
; subsequent credits elements will be displayed on separate lines.
; CRED_TEXT, CRED_TEXT_FADE, CRED_TEXT_MON, and CRED_TEXT_FADE_MON are
; commands that are used to go to the next set of credits texts.
	db CRED_POKEMON, CRED_VERSION, CRED_TEXT_FADE_MON
	db CRED_DIRECTOR, CRED_TAJIRI, CRED_TEXT_FADE_MON
	db CRED_PROGRAMMERS, CRED_OOTA, CRED_MORIMOTO, CRED_WATANABE, CRED_TEXT_FADE
	db CRED_PROGRAMMERS, CRED_MASUDA, CRED_TAMADA, CRED_TEXT_MON
	db CRED_CHARACTER_DESIGN, CRED_SUGIMORI, CRED_NISHIDA, CRED_TEXT_FADE_MON
	db CRED_MUSIC, CRED_MASUDA, CRED_TEXT_FADE
	db CRED_SOUND_EFFECTS, CRED_MASUDA, CRED_WATANABE, CRED_TEXT_MON
	db CRED_GAME_DESIGN, CRED_TAJIRI, CRED_NISHINO, CRED_TEXT_FADE_MON
	db CRED_MONSTER_DESIGN, CRED_SUGIMORI, CRED_NISHIDA, CRED_YOSHIDA, CRED_TEXT_FADE_MON
	db CRED_GAME_SCENARIO, CRED_TAJIRI, CRED_TEXT_FADE
	db CRED_GAME_SCENARIO, CRED_MATSUMITA, CRED_TEXT_MON
	db CRED_PARAMETRIC_DESIGN, CRED_NISHINO, CRED_TEXT_FADE_MON
	db CRED_MAP_DESIGN, CRED_TAJIRI, CRED_NISHINO, CRED_SEYA, CRED_TEXT_FADE_MON
	db CRED_TESTING, CRED_SEKINE, CRED_SEYA, CRED_TEXT_FADE
	db CRED_TESTING, CRED_SHIMAMURA, CRED_SHIMOYAMADA, CRED_TEXT_MON
	db CRED_SPECIAL_THANKS, CRED_SHOGAKUKAN, CRED_TEXT_FADE_MON
	db CRED_PIKACHU_VOICE, CRED_OOTANI, CRED_TEXT_FADE_MON
	db CRED_PRODUCER, CRED_IZUSHI, CRED_TEXT_FADE
	db CRED_PRODUCER, CRED_KAWAGUCHI, CRED_TEXT
	db CRED_PRODUCER, CRED_ISHIHARA, CRED_TEXT_MON
	db CRED_U_S_STAFF, CRED_TEXT_FADE
	db CRED_U_S_COORD, CRED_TILDEN, CRED_TEXT_FADE
	db CRED_U_S_COORD, CRED_KAWAKAMI, CRED_NAKAMURA2, CRED_TEXT
	db CRED_U_S_COORD, CRED_SHOEMAKE, CRED_OSBORNE, CRED_TEXT
	db CRED_TRANSLATION, CRED_OGASAWARA, CRED_TEXT_FADE
	db CRED_PROGRAMMERS, CRED_MURAKAWA, CRED_FUKUI, CRED_TEXT_FADE
	db CRED_CHARACTER_DESIGN, CRED_HOSOKAWA, CRED_TEXT_FADE
	db CRED_SPECIAL_THANKS, CRED_OKUBO, CRED_HARADA2, CRED_TEXT_FADE
	db CRED_SPECIAL_THANKS, CRED_NAKAMICHI, CRED_YOSHIMURA, CRED_YAMAZAKI, CRED_TEXT
	db CRED_TESTING, CRED_PAAD, CRED_SUPER_MARIO_CLUB2, CRED_TEXT_FADE
	db CRED_EXECUTIVE_PRODUCER, CRED_YAMAUCHI, CRED_TEXT_FADE_MON
; new stuff
	db CRED_PRET, CRED_DANNYE, CRED_ISSOTM, CRED_AX6, CRED_TEXT_FADE
	db CRED_PRET, CRED_LUCKYTYPHLOSION, CRED_RANGI42, CRED_CRYSTAL, CRED_TEXT_FADE
	db CRED_PRET, CRED_CRAMODEV, CRED_PORYGONDOLIER, CRED_TEXT_FADE_MON
	db CRED_PRET, CRED_VORTIENE, CRED_JOJO, CRED_TEXT_FADE
	db CRED_PRET, CRED_MORD, CRED_BLUEZANGOOSE, CRED_XILLICIS, CRED_TEXT_FADE
	db CRED_PRET, CRED_PLAGUEVONKARMA, CRED_SATOMEW, CRED_SANQUI, CRED_TEXT_FADE_MON
	db CRED_PRET, CRED_FRENCHORANGE, CRED_MAUVESEA, CRED_LJSTAR, CRED_TEXT_FADE
	db CRED_EXTREMEYELLOW, CRED_RAINBOWMETALPIGEON, CRED_TEXT_FADE_MON
; back to vanilla
	db CRED_COPYRIGHT, CRED_TEXT_FADE_MON
	db CRED_THE_END
