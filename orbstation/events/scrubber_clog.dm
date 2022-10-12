/// Wizard or admin scrubber clog with weird animals
/datum/round_event_control/scrubber_clog/fantastical
	name = "Scrubber Clog: Fantastical"
	typepath = /datum/round_event/scrubber_clog/fantastical
	weight = 0
	max_occurrences = 0
	description = "Dangerous magical mobs climb out of a scrubber."

/datum/round_event/scrubber_clog/fantastical
	maximum_spawns = 3

/datum/round_event/scrubber_clog/fantastical/get_mob()
	var/static/list/mob_list = list(
		/mob/living/simple_animal/slime/random,
		/mob/living/simple_animal/hostile/skeleton,
		/mob/living/simple_animal/hostile/killertomato,
		/mob/living/simple_animal/hostile/ooze,
		/mob/living/simple_animal/hostile/asteroid/hivelordbrood/legion,
	)
	return pick(mob_list)

/datum/round_event/scrubber_clog/fantastical/announce()
	priority_announce("Anomalous lifesigns detected in the [get_area_name(scrubber)] ventilation network.", "Security Alert")

/// Notify ghosts about which vent has stuff coming out of if
/datum/round_event/scrubber_clog/setup()
	. = ..()
	announce_to_ghosts(scrubber)
