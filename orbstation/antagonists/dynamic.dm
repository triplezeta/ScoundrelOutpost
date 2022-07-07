/datum/game_mode/dynamic
	///Number of antagonists that count towards the traitor limit.
	///(Generally, antagonists that spawn as members of the crew, aside from thieves.)
	var/traitor_limit_antag_count = 0
	///Theoretical percentage of crew that can become traitors at 100 threat.
	///Used to calculate maximum traitor count for current population and threat level.
	///Remember that threat level generally falls somewhere around 50.
	///Configurable in dynamic.json.
	var/max_threat_traitor_percent = 0.5

///Calculates the limit for midround/latejoin traitor spawns based on current population and threat level.
///Returns TRUE or FALSE depending on if more traitors can spawn or not.
/datum/game_mode/dynamic/proc/calculate_traitor_limit()
	var/traitor_limit = round(((threat_level / 100) * max_threat_traitor_percent) * GLOB.alive_player_list.len, 1)

	if(traitor_limit_antag_count >= traitor_limit)
		return FALSE

	return TRUE

/datum/dynamic_ruleset
	///If set to TRUE, the game will count antags spawned by this ruleset when limiting how many midround/latejoin traitors can spawn.
	var/counts_toward_traitor_limit = FALSE
