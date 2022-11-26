/**
 * Abyssal Gaze but for an actual wizard, so it's not a fluff ability
 * Basically makes one person unable to fight you as long as you keep casting it on them
 */
/datum/action/cooldown/spell/pointed/abyssal_gaze/greater
	name = "Greater Abyssal Gaze"
	cooldown_time = 15 SECONDS
	blind_duration = 10 SECONDS
	cooldown_reduction_per_rank = 1 SECONDS
