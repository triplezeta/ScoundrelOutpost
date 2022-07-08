//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/autotraitor
	counts_toward_traitor_limit = TRUE

// Don't create more traitors if it exceeds the limit for the current population & threat level.
/datum/dynamic_ruleset/midround/autotraitor/ready(forced = FALSE)
	if(!forced)
		if(!mode.calculate_traitor_limit())
			message_admins("Midround ruleset [name] could not be executed due to the traitor limit.")
			return FALSE
	return ..()

/datum/dynamic_ruleset/midround/autotraitor/execute()
	mode.traitor_limit_antag_count ++
	return ..()

//////////////////////////////////////////////
//                                          //
//         CHANGELING INFILTRATOR           //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator
	name = "Changeling Infiltrator"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT
	antag_flag = ROLE_CHANGELING
	weight = 3
	cost = 12
	requirements = list(70,60,50,50,40,20,20,10,10,10)
	required_candidates = 1
	repeatable = FALSE

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/new_mob = spawn_changeling_infiltrator(applicant)
	return new_mob

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator/finish_setup(mob/new_character, index)
	return // the spawned player is given the antag datum via the spawner, so we don't need to do it here
