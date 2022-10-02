/datum/language/ratvaric
	name = "Ratvaric"
	desc = "The common language of ratfolk, derived from an ancient, forgotten culture."
	key = "r"
	space_chance = 30
	syllables = list(
		"ch", "sk", "pst", "squee", "ka", "ki", "ko", "xa", "xi", "ra", "ro", "ri", "ik", "ak"
	)
	icon = 'orbstation/icons/misc/language.dmi'
	icon_state = "rat"
	default_priority = 90

/datum/language_holder/ratfolk
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/ratvaric = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/ratvaric = list(LANGUAGE_ATOM))
