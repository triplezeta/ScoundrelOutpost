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
		for (var/objective in subtypesof(/datum/objective_item/steal/owned))
			new objective

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
	/// If true, will not be added to list of objectives
	var/abstract = FALSE

/datum/objective_item/steal/owned/New()
	if (abstract || !TargetExists())
		qdel(src)
		return
	GLOB.owned_theft_items += src

/datum/objective_item/steal/owned/proc/owner_exists()
	if (!owner || owner.len == 0)
		return TRUE
	for (var/mob/player as anything in GLOB.player_list)
		if (player.stat == DEAD)
			continue
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

/datum/objective_item/steal/owned/curator_key
	name = "the curator's display case key"
	targetitem = /obj/item/key/displaycase
	excludefromjob = list(JOB_CURATOR)
	owner = list(JOB_CURATOR)

/datum/objective_item/steal/owned/captain_suit
	name = "the captain's modular suit"
	targetitem = /obj/item/mod/control/pre_equipped/magnate
	difficulty = 5
	excludefromjob = list(JOB_CAPTAIN)
	exists_on_map = TRUE
	owner = list(JOB_CAPTAIN)

/datum/objective_item/steal/owned/ce_suit
	name = "the chief engineer's modular suit"
	targetitem = /obj/item/mod/control/pre_equipped/advanced
	difficulty = 5
	excludefromjob = list(JOB_CHIEF_ENGINEER)
	exists_on_map = TRUE
	owner = list(JOB_CHIEF_ENGINEER)

/datum/objective_item/steal/owned/hos_suit
	name = "the head of security's modular suit"
	targetitem = /obj/item/mod/control/pre_equipped/safeguard
	difficulty = 5
	excludefromjob = list(JOB_HEAD_OF_SECURITY)
	exists_on_map = TRUE
	owner = list(JOB_HEAD_OF_SECURITY)

/datum/objective_item/steal/owned/rd_suit
	name = "the research director's modular suit"
	targetitem = /obj/item/mod/control/pre_equipped/research
	difficulty = 5
	excludefromjob = list(JOB_RESEARCH_DIRECTOR)
	exists_on_map = TRUE
	owner = list(JOB_RESEARCH_DIRECTOR)

/datum/objective_item/steal/owned/cmo_suit
	name = "the chief medical officer's modular suit"
	targetitem = /obj/item/mod/control/pre_equipped/rescue
	difficulty = 5
	excludefromjob = list(JOB_CHIEF_MEDICAL_OFFICER)
	exists_on_map = TRUE
	owner = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/objective_item/steal/owned/loader
	name = "the cargo loader suit"
	targetitem = /obj/item/mod/control/pre_equipped/loader
	difficulty = 5
	excludefromjob = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN, JOB_SHAFT_MINER)
	exists_on_map = TRUE
	owner = list(JOB_QUARTERMASTER, JOB_CARGO_TECHNICIAN)

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

/datum/objective_item/steal/owned/chain_command
	name = "the chain of command"
	targetitem = /obj/item/melee/chainofcommand
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

/datum/objective_item/steal/owned/blueprints
	name = "the original station blueprints" // Wizards aren't satisfied with a photograph
	targetitem = /obj/item/areaeditor/blueprints
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

/datum/objective_item/steal/owned/pet
	abstract = TRUE
	name = "a pet"
	targetitem = /obj/item/clothing/head/mob_holder
	difficulty = 5
	/// Typepaths of pet to steal
	var/list/pet_type

/datum/objective_item/steal/owned/pet/check_special_completion(obj/item/clothing/head/mob_holder/holder)
	if (!istype(holder))
		return FALSE
	if (!holder.held_mob)
		return FALSE
	return (is_type_in_list(holder.held_mob, pet_type))

/obj/item/clothing/head/mob_holder/add_stealing_item_objective()
	GLOB.steal_item_handler.objectives_by_path[/obj/item/clothing/head/mob_holder] += src

/datum/objective_item/steal/owned/pet/ian
	abstract = FALSE
	name = "Ian, without a pet carrier."
	pet_type = list(/mob/living/simple_animal/pet/dog/corgi/ian, /mob/living/simple_animal/pet/dog/corgi/puppy/ian)
	excludefromjob = list(JOB_HEAD_OF_PERSONNEL)
	owner = list(JOB_HEAD_OF_PERSONNEL)

/datum/objective_item/steal/owned/pet/renault
	abstract = FALSE
	name = "Renault, without a pet carrier."
	pet_type = list(/mob/living/simple_animal/pet/fox/renault)
	excludefromjob = list(JOB_CAPTAIN)
	owner = list(JOB_CAPTAIN)

/datum/objective_item/steal/owned/pet/runtime
	abstract = FALSE
	name = "Runtime, without a pet carrier."
	pet_type = list(/mob/living/simple_animal/pet/cat/runtime)
	excludefromjob = list(JOB_CHIEF_MEDICAL_OFFICER)
	owner = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/objective_item/steal/owned/lamarr
	name = "the research director's pet facehugger"
	targetitem = /obj/item/clothing/mask/facehugger/lamarr
	difficulty = 5
	excludefromjob = list(JOB_RESEARCH_DIRECTOR)
	exists_on_map = TRUE
	owner = list(JOB_RESEARCH_DIRECTOR)
