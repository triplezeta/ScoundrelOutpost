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
	midround_ruleset_style = MIDROUND_RULESET_STYLE_HEAVY
	antag_flag = ROLE_CHANGELING
	weight = 5
	cost = 12
	requirements = list(101,60,50,50,40,20,20,10,10,10)
	required_candidates = 1
	repeatable = FALSE

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator/generate_ruleset_body(mob/applicant)
	var/mob/living/carbon/human/new_mob = spawn_changeling_infiltrator(applicant)
	return new_mob

/datum/dynamic_ruleset/midround/from_ghosts/changeling_infiltrator/finish_setup(mob/new_character, index)
	return // the spawned player is given the antag datum via the spawner, so we don't need to do it here

//////////////////////////////////////////////
//                                          //
//            HERETIC (MIDROUND)            //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/waking_heretic
	name = "Waking Heretic"
	midround_ruleset_style = MIDROUND_RULESET_STYLE_LIGHT // heretics need time to set up, so this should happen earlier in the round
	antag_datum = /datum/antagonist/heretic
	antag_flag = ROLE_HERETIC_MIDROUND
	antag_flag_override = ROLE_HERETIC
	protected_roles = list(
		JOB_CAPTAIN,
		JOB_DETECTIVE,
		JOB_HEAD_OF_SECURITY,
		JOB_PRISONER,
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
	)
	restricted_roles = list(
		JOB_AI,
		JOB_CYBORG,
		ROLE_POSITRONIC_BRAIN,
	)
	enemy_roles = list(
		JOB_HEAD_OF_SECURITY,
		JOB_DETECTIVE,
		JOB_WARDEN,
		JOB_SECURITY_OFFICER,
	)
	requirements = list(10,101,50,40,35,20,20,15,10,10)
	required_enemies = list(1,1,1,1,1,1,1,1,1,1) // the game is supposed to make one of your sac targets a security member
	required_candidates = 1
	minimum_players = 15 // same as the other heretic roles as listed in our dynamic.json
	weight = 3
	cost = 10
	repeatable = TRUE

/datum/dynamic_ruleset/midround/waking_heretic/trim_candidates()
	..()
	for(var/mob/living/player in living_players)
		if(issilicon(player))
			living_players -= player
		else if(is_centcom_level(player.z))
			living_players -= player
		else if(player.mind && (player.mind.special_role || player.mind.antag_datums?.len > 0))
			living_players -= player

/datum/dynamic_ruleset/midround/waking_heretic/ready(forced = FALSE)
	if (required_candidates > living_players.len)
		log_game("DYNAMIC: FAIL: [src] does not have enough candidates, using living_players ([required_candidates] needed, [living_players.len] found)")
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/waking_heretic/execute()
	var/mob/M = pick(living_players)
	assigned += M
	living_players -= M
	var/datum/antagonist/heretic/new_heretic = new
	M.mind.add_antag_datum(new_heretic)
	message_admins("[ADMIN_LOOKUPFLW(M)] was selected by the [name] ruleset and has been made into a midround heretic.")
	log_game("DYNAMIC: [key_name(M)] was selected by the [name] ruleset and has been made into a midround heretic.")
	return TRUE
