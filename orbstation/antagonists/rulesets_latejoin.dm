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
