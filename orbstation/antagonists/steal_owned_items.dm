GLOBAL_LIST_EMPTY(owned_theft_items)
/datum/objective/steal/owned
	name = "steal (owned only)"

/datum/objective/steal/owned/New()
	..()
	if(!GLOB.owned_theft_items.len)
		for(var/I in subtypesof(/datum/objective_item/owned_theft_items) + subtypesof(/datum/objective_item/stack))
			new I

/datum/objective/steal/owned/find_target(dupe_search_range)
	return set_target(pick(GLOB.owned_theft_items))

/datum/objective_item/steal/owned
	/// Will only spawn if this job exists in the round.
	var/list/owner

/datum/objective_item/steal/owned/TargetExists()
	return ..() && owner_exists()

/datum/objective_item/steal/owned/proc/owner_exists()
	if (!owner || owner.len == 0)
		return TRUE
	for(var/mob/player as anything in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(player.job != job)
			continue
		if(is_centcom_level(player.z))
			continue
		return TRUE
	return FALSE

/datum/objective_item/steal/owned/bartender_shotgun
	name = "the bartender's shotgun"
	targetitem = /obj/item/gun/ballistic/shotgun/doublebarrel
	excludefromjob = list(JOB_BARTENDER)
	exists_on_map = TRUE

/datum/objective_item/steal/owned/fireaxe
	name = "a fire axe"
	targetitem = /obj/item/fireaxe
	excludefromjob = list(JOB_CHIEF_ENGINEER,JOB_STATION_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)
	exists_on_map = TRUE

/datum/objective_item/steal/owned/nullrod
	name = "the chaplain's null rod"
	targetitem = /obj/item/nullrod
	exists_on_map = TRUE

/datum/objective_item/steal/owned/clown_shoes
	name = "the clown's shoes"
	targetitem = /obj/item/clothing/shoes/clown_shoes
	excludefromjob = list(JOB_CLOWN)
	owner = JOB_CLOWN
