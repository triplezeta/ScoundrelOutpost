
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
