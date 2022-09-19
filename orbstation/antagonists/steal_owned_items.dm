GLOBAL_LIST_EMPTY(owned_theft_items)

/**
 * An objective to steal something, but only if someone who cares that you would do it is around.
 * Will return "Free Objective" if there are no valid items.
 */
/datum/objective/steal/owned
	name = "steal (owned only)"

/datum/objective/steal/owned/New(text)
	if(text)
		explanation_text = text
	if (!GLOB.owned_theft_items.len)
		for (var/I in subtypesof(/datum/objective_item/steal/owned))
			new I

/**
 * Creates a target for this objective.
 * Arguments
 * * dupe_search_range - A list of minds to check for existing objectives to avoid generating duplicate targets.
 */
/datum/objective/steal/owned/find_target(dupe_search_range)
	var/list/approved_targets = list()
	var/list/datum/mind/owners = get_owners()
	for (var/datum/objective_item/steal/owned/possible_item in GLOB.owned_theft_items)
		if (!possible_item.owner_exists())
			continue
		if (!is_unique_objective(possible_item.targetitem, dupe_search_range))
			continue
		for (var/datum/mind/M in owners)
			if(M.current.mind.assigned_role.title in possible_item.excludefromjob)
				continue
		approved_targets += possible_item
	if (approved_targets.len)
		return set_target(pick(approved_targets))
	return set_target(null)

/**
 * An item to steal, which belongs to someone who cares about it.
 */
/datum/objective_item/steal/owned
	/// Will only trigger if this job currently exists in the round.
	var/list/owner

/datum/objective_item/steal/owned/New()
	if(TargetExists())
		GLOB.owned_theft_items += src
	else
		qdel(src)

/datum/objective_item/steal/owned/proc/owner_exists()
	if (!owner || owner.len == 0)
		return TRUE
	for (var/mob/player as anything in GLOB.player_list)
		if (player.stat == DEAD)
			continue
		to_chat(world, "test [player.mind?.assigned_role.title]")
		if (!(player.mind?.assigned_role.title in owner))
			continue
		if (is_centcom_level(player.z))
			continue
		return TRUE
	return FALSE

/datum/objective_item/steal/owned/bartender_shotgun
	name = "the bartender's shotgun"
	targetitem = /obj/item/gun/ballistic/shotgun/doublebarrel
	excludefromjob = list(JOB_BARTENDER)
	exists_on_map = TRUE
	owner = list(JOB_BARTENDER)

/datum/objective_item/steal/owned/fireaxe
	name = "a fire axe"
	targetitem = /obj/item/fireaxe
	excludefromjob = list(JOB_CHIEF_ENGINEER,JOB_STATION_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)
	exists_on_map = TRUE
	owner = list(JOB_CHIEF_ENGINEER,JOB_STATION_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)

/datum/objective_item/steal/owned/nullrod
	name = "the chaplain's null rod"
	targetitem = /obj/item/nullrod
	excludefromjob = list(JOB_CHAPLAIN)
	exists_on_map = TRUE
	owner = list(JOB_CHAPLAIN)

/datum/objective_item/steal/owned/clown_shoes
	name = "the clown's shoes"
	targetitem = /obj/item/clothing/shoes/clown_shoes
	excludefromjob = list(JOB_CLOWN, JOB_CARGO_TECHNICIAN, JOB_QUARTERMASTER)
	owner = list(JOB_CLOWN)

/datum/objective_item/steal/owned/caplaser
	name = "the captain's antique laser gun"
	targetitem = /obj/item/gun/energy/laser/captain
	difficulty = 5
	excludefromjob = list(JOB_CAPTAIN)
	exists_on_map = TRUE
	owner = list(JOB_CAPTAIN)

/datum/objective_item/steal/owned/capmedal
	name = "the medal of captaincy"
	targetitem = /obj/item/clothing/accessory/medal/gold/captain
	difficulty = 5
	excludefromjob = list(JOB_CAPTAIN)
	exists_on_map = TRUE
	owner = list(JOB_CAPTAIN)

/datum/objective_item/steal/owned/hoslaser
	name = "the head of security's personal laser gun"
	targetitem = /obj/item/gun/energy/e_gun/hos
	difficulty = 10
	excludefromjob = list(JOB_HEAD_OF_SECURITY)
	exists_on_map = TRUE
	owner = list(JOB_HEAD_OF_SECURITY)

/datum/objective_item/steal/owned/magboots
	name = "the chief engineer's advanced magnetic boots"
	targetitem = /obj/item/clothing/shoes/magboots/advance
	difficulty = 5
	excludefromjob = list(JOB_CHIEF_ENGINEER)
	exists_on_map = TRUE
	owner = list(JOB_CHIEF_ENGINEER)

/datum/objective_item/steal/owned/hypo
	name = "the hypospray"
	targetitem = /obj/item/reagent_containers/hypospray/cmo
	difficulty = 5
	excludefromjob = list(JOB_CHIEF_MEDICAL_OFFICER)
	exists_on_map = TRUE
	owner = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/objective_item/steal/owned/reflector
	name = "a reflector trenchcoat"
	targetitem = /obj/item/clothing/suit/hooded/ablative
	difficulty = 3
	excludefromjob = list(JOB_HEAD_OF_SECURITY, JOB_WARDEN)
	exists_on_map = TRUE
	owner = list(JOB_HEAD_OF_SECURITY, JOB_WARDEN)

/datum/objective_item/steal/owned/reactive
	name = "the reactive teleport armor"
	targetitem = /obj/item/clothing/suit/armor/reactive/teleport
	difficulty = 5
	excludefromjob = list(JOB_RESEARCH_DIRECTOR)
	exists_on_map = TRUE
	owner = list(JOB_RESEARCH_DIRECTOR)

/datum/objective_item/steal/owned/slime
	name = "an unused sample of slime extract"
	targetitem = /obj/item/slime_extract
	difficulty = 3
	excludefromjob = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST)
	owner = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST)

/datum/objective_item/steal/owned/corgimeat
	name = "a piece of corgi meat"
	targetitem = /obj/item/food/meat/slab/corgi
	difficulty = 5
	excludefromjob = list(JOB_HEAD_OF_PERSONNEL)
	owner = list(JOB_HEAD_OF_PERSONNEL)
