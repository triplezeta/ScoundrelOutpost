//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/infiltrator
	counts_toward_traitor_limit = TRUE

// Don't create more traitors if it exceeds the limit for the current population & threat level.
/datum/dynamic_ruleset/latejoin/infiltrator/ready(forced = FALSE)
	if(!forced)
		if(!mode.calculate_traitor_limit())
			return FALSE
	return ..()

//////////////////////////////////////////////
//                                          //
//           HERETIC SMUGGLER               //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/latejoin/heretic_smuggler
	enemy_roles = list(
		JOB_HEAD_OF_SECURITY,
		JOB_DETECTIVE,
		JOB_WARDEN,
		JOB_SECURITY_OFFICER,
	)
	requirements = list(101,101,50,40,35,20,20,15,10,10)
	required_enemies = list(1,1,1,1,1,1,1,1,1,1) // the game is supposed to make one of your sac targets a security member
	minimum_players = 15 // same as the other heretic roles as listed in our dynamic.json
