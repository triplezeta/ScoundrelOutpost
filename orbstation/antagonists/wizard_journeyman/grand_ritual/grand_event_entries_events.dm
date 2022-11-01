/**
 * Rune events which trigger an event from the random event manager.
 */

/datum/grand_event/event/anomaly_bioscrambler
	min_escalation = 0
	max_escalation = 2
	event_control_path = /datum/round_event_control/anomaly/anomaly_bioscrambler
	wizard_message = "You sense chaotic energies coalesce elsewhere."

/datum/grand_event/event/anomaly_bluespace
	min_escalation = 0
	max_escalation = 2
	event_control_path = /datum/round_event_control/anomaly/anomaly_bluespace
	wizard_message = "You sense azure energies coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_dimensional
	min_escalation = 0
	max_escalation = 2
	event_control_path = /datum/round_event_control/anomaly/anomaly_dimensional
	wizard_message = "You sense chaotic energies coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_flux
	min_escalation = 1
	max_escalation = 4
	event_control_path = /datum/round_event_control/anomaly/anomaly_flux
	wizard_message = "You sense powerful energies coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_grav
	min_escalation = 1
	max_escalation = 3
	event_control_path = /datum/round_event_control/anomaly/anomaly_grav
	wizard_message = "You sense gravitational forces coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_hallucination
	min_escalation = 0
	max_escalation = 2
	event_control_path = /datum/round_event_control/anomaly/anomaly_hallucination
	wizard_message = "You sense chaotic energies coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_pyro
	min_escalation = 1
	max_escalation = 4
	event_control_path = /datum/round_event_control/anomaly/anomaly_pyro
	wizard_message = "You sense burning energies coalesce elsewhere."

/datum/grand_event/event/anomaly/anomaly_vortex
	min_escalation = 6
	max_escalation = 7
	event_control_path = /datum/round_event_control/anomaly/anomaly_vortex
	wizard_message = "You sense howling energies coalesce elsewhere."

/datum/grand_event/event/anomaly/brand_intelligence
	min_escalation = 3
	max_escalation = 6
	event_control_path = /datum/round_event_control/brand_intelligence
	wizard_message = "A mischevious spirit is attracted by the expenditure of power!"

/datum/grand_event/event/carp_migration
	min_escalation = 0
	max_escalation = 3
	event_control_path = /datum/round_event_control/brand_intelligence
	wizard_message = "Your meddling attracts a shoal of carp!"

/datum/grand_event/event/magic_carp
	min_escalation = 4
	max_escalation = 6
	event_control_path = /datum/round_event_control/wizard/magicarp
	wizard_message = "Your meddling attracts a shoal of carp!"

/datum/grand_event/event/carp_storm
	min_escalation = 2
	max_escalation = 6
	event_control_path = /datum/round_event_control/portal_storm_carp
	wizard_message = "You create a gateway to the carp migration stream!"

/datum/grand_event/event/carp_rift
	min_escalation = 5
	max_escalation = 7
	event_control_path = /datum/round_event_control/carp_rift
	wizard_message = "You create a gateway to the carp migration stream!"

/datum/grand_event/event/communications_blackout
	min_escalation = 0
	max_escalation = 3
	event_control_path = /datum/round_event_control/communications_blackout
	wizard_message = "Your released energies deaden the crew's equipment!"

/datum/grand_event/event/disease_outbreak
	min_escalation = 2
	max_escalation = 6
	event_control_path = /datum/round_event_control/disease_outbreak
	wizard_message = "Your released energies coalesce into a terrible malady!"

/datum/grand_event/event/space_dust
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/space_dust/major_dust
	wizard_message = "Your released energies magnetise space debris towards the station!"

/datum/grand_event/event/electrical_storm
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/electrical_storm
	wizard_message = "Your released energies discharge into the station's power net!"

/datum/grand_event/event/no_gravity
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/gravity_generator_blackout
	wizard_message = "Your power lifts the crew off their feet!"

/datum/grand_event/event/grid_check
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/grid_check
	wizard_message = "Your released energies discharge into the station's power net!"

/datum/grand_event/event/heart_attack
	min_escalation = 6
	max_escalation = 7
	event_control_path = /datum/round_event_control/heart_attack
	wizard_message = "You unleash a terrible curse!"

/datum/grand_event/event/immovable_rod
	min_escalation = 6
	max_escalation = 7
	event_control_path = /datum/round_event_control/immovable_rod
	wizard_message = "Your released energies resonate with a nearby magical artifact!"

/datum/grand_event/event/ion_storm
	min_escalation = 3
	max_escalation = 7
	event_control_path = /datum/round_event_control/ion_storm
	wizard_message = "The ritual unleashes ionic fallout!"

/// Don't make an Ion law if there's no silicons
/datum/grand_event/event/ion_storm/is_valid_event(escalation)
	. = ..()
	if (!.)
		return

	// Allow the event if we have any living silicons with minds who aren't pAIs.
	for(var/mob/living/silicon/law_haver as anything in GLOB.silicon_mobs)
		if (ispAI(law_haver))
			continue
		if (law_haver.stat == DEAD)
			continue
		if (!law_haver.mind)
			continue
		return TRUE

	return FALSE

/datum/grand_event/event/hallucination
	min_escalation = 0
	max_escalation = 2
	event_control_path = /datum/round_event_control/mass_hallucination
	wizard_message = "You create a powerful illusion!"

/datum/grand_event/event/cult_storm
	min_escalation = 6
	max_escalation = 7
	event_control_path = /datum/round_event_control/portal_storm_narsie
	wizard_message = "You tap into a rift between worlds!"

/datum/grand_event/event/clown_storm
	min_escalation = 2
	max_escalation = 6
	event_control_path = /datum/round_event_control/portal_storm_clown
	wizard_message = "You tap into a rift between worlds!"

/datum/grand_event/event/grey_tide
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/grey_tide
	wizard_message = "Your released energies discharge into the station's power net!"

/datum/grand_event/event/rad_storm
	min_escalation = 3
	max_escalation = 7
	event_control_path = /datum/round_event_control/radiation_storm
	wizard_message = "The ritual unleashes magical fallout!"

/datum/grand_event/event/clog_major
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/scrubber_clog/major
	wizard_message = "You complete a minor summoning!"

/datum/grand_event/event/clog_critical
	min_escalation = 3
	max_escalation = 6
	event_control_path = /datum/round_event_control/scrubber_clog/critical
	wizard_message = "You complete a minor summoning!"

/datum/grand_event/event/clog_fantastical
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/scrubber_clog/fantastical
	wizard_message = "You complete a minor summoning!"

/datum/grand_event/event/clog_strange
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/scrubber_clog/strange
	wizard_message = "You complete a minor summoning!"

/datum/grand_event/event/scrubber_overflow
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/scrubber_overflow/threatening
	wizard_message = "You complete an alchemical equation!"

/datum/grand_event/event/scrubber_overflow_threatening
	min_escalation = 3
	max_escalation = 6
	event_control_path = /datum/round_event_control/scrubber_overflow/catastrophic
	wizard_message = "You complete an alchemical equation!"

/datum/grand_event/event/ghost/sentience
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/sentience
	wizard_message = "A mischevious spirit is attracted by the expenditure of power!"

/datum/grand_event/event/vines
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/spacevine
	wizard_message = "The ritual releases a wave of rapid plant growth!"
	once_only = TRUE

/datum/grand_event/event/spider_infestation
	min_escalation = 5
	max_escalation = 7
	event_control_path = /datum/round_event_control/spider_infestation
	wizard_message = "Your released energies grow some vermin to incredible size!"
	once_only = TRUE

/datum/grand_event/event/stray_cargo
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/stray_cargo
	wizard_message = "You summon some mundane objects!"

/datum/grand_event/event/stray_cargo_syndicate
	min_escalation = 3
	max_escalation = 6
	event_control_path = /datum/round_event_control/stray_cargo/syndicate
	wizard_message = "You summon some dangerous objects!"

/datum/grand_event/event/stray_meteor
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/stray_meteor
	wizard_message = "Your released energies magnetise space debris towards the station!"

/datum/grand_event/event/wormholes
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/wormholes
	wizard_message = "You tear open a hole in reality!"

/datum/grand_event/event/robeless
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/robelesscasting
	wizard_message = "You tap directly into a ley line, you can feel the power flowing through you!"
	once_only = TRUE

/datum/grand_event/event/fast_cast
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/improvedcasting
	wizard_message = "You tap directly into a ley line, you can feel the power flowing through you!"

/datum/grand_event/event/blob_zombies
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event/wizard/blobies
	wizard_message = "The ritual releases a wave of rapid fungal growth!"

/// Only allow if there's some corpses on the station
/datum/grand_event/event/blob_zombies/is_valid_event(escalation)
	. = ..()
	if (!.)
		return
	for (var/mob/living/carbon/human/corpse in GLOB.dead_mob_list)
		if(!is_station_level(corpse.z))
			continue
		return TRUE
	return FALSE

/datum/grand_event/event/pointiness
	min_escalation = 3
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/embedpocalypse
	wizard_message = "You cast a powerful enchantment!"
	once_only = TRUE

/datum/grand_event/event/ghost/visible_ghosts
	min_escalation = 0
	max_escalation = 7
	min_candidates = 1
	event_control_path = /datum/round_event_control/wizard/ghost
	wizard_message = "You forge a bridge between the worlds of the living and the dead!"

/datum/grand_event/event/greentext
	min_escalation = 6
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/greentext
	wizard_message = "You summon a powerful artifact!"
	once_only = TRUE

/datum/grand_event/event/ghost/imposter
	min_escalation = 2
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/imposter
	wizard_message = "You tear open a hole in reality!"
	once_only = TRUE

/datum/grand_event/event/floor_lava
	min_escalation = 5
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/lava
	wizard_message = "You connect this world with the plane of fire!"

/datum/grand_event/event/pet_duplication
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/wizard/petsplosion
	wizard_message = "The ritual releases a wave of rapid animal growth!"

/datum/grand_event/event/rpg_loot
	min_escalation = 5
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/rpgloot
	wizard_message = "You cast a powerful enchantment!"
	once_only = TRUE

/datum/grand_event/event/rpg_titles
	min_escalation = 4
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/rpgtitles
	wizard_message = "You cast a powerful enchantment!"
	once_only = TRUE

/datum/grand_event/event/relocate
	min_escalation = 0
	max_escalation = 7
	event_control_path = /datum/round_event_control/wizard/shuffleloc
	wizard_message = "You tear open a hole in reality!"

/datum/grand_event/event/rain_pets
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/wizard/indoor_weather_animal
	wizard_message = "Your power creates localised weather!"

/datum/grand_event/event/rain_food
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/wizard/indoor_weather_food
	wizard_message = "Your power creates localised weather!"

/datum/grand_event/event/rain_money
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/wizard/indoor_weather_cash
	wizard_message = "Your power creates localised weather!"

/datum/grand_event/event/rain_fish
	min_escalation = 0
	max_escalation = 4
	event_control_path = /datum/round_event_control/wizard/indoor_weather_fish
	wizard_message = "Your power creates localised weather!"
