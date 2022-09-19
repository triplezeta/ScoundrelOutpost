GLOBAL_LIST_EMPTY(journeymanstart)

/datum/job/wizard_journeyman
	title = "Wizard Journeyman"
	faction = ROLE_WIZARD

/datum/antagonist/wizard_journeyman
	var/static/lair_exists = FALSE
	name = "\improper Space Wizard Journeyman"
	roundend_category = "wizards/witches"
	antagpanel_category = "Wizard"
	job_rank = ROLE_WIZARD
	antag_hud_name = "wizard"
	antag_moodlet = /datum/mood_event/focused
	hijack_speed = 0.5
	ui_name = "AntagInfoWizard"
	suicide_cry = "FOR THE FEDERATION!!"
	preview_outfit = /datum/outfit/wizard
	var/give_objectives = TRUE
	var/outfit_type = /datum/outfit/wizard
	show_to_ghosts = TRUE

/datum/antagonist/wizard_journeyman/on_gain()
	send_to_lair()
	equip_wizard()
	if (give_objectives)
		create_objectives()
	grant_hangover()
	. = ..()
	rename_wizard()

/datum/antagonist/wizard_journeyman/proc/equip_wizard()
	if (!owner)
		CRASH("Antag datum with no owner.")
	var/mob/living/carbon/human/graduate = owner.current
	if (!istype(graduate))
		return
	graduate.delete_equipment()
	// Wizards are human by default. Use the mirror if you want something else.
	graduate.set_species(/datum/species/human)
	graduate.equipOutfit(outfit_type)

/datum/antagonist/wizard_journeyman/proc/create_objectives()
	add_theft_objective()
	switch(rand(1,100))
		if (1 to 40)
			add_theft_objective()
		if (41 to 90)
			add_maroon_objective()
		if (91 to 100)
			add_diskie_objective()
	add_roundend_objective()

/datum/antagonist/wizard_journeyman/proc/add_theft_objective()
	var/datum/objective/steal/owned/theft = new
	theft.owner = owner
	theft.find_target(list(owner))
	objectives += theft

/datum/antagonist/wizard_journeyman/proc/add_maroon_objective()
	var/datum/objective/protect/protect = new
	protect.owner = owner
	protect.find_target()

	var/datum/objective/maroon/maroon = new
	maroon.owner = owner
	maroon.target = protect.target
	maroon.update_explanation_text()

	objectives += protect
	objectives += maroon

/datum/antagonist/wizard_journeyman/proc/add_diskie_objective()
	var/datum/objective/steal/theft = new
	theft.owner = owner
	theft.set_target(new /datum/objective_item/steal/nukedisc)
	objectives += theft

/datum/antagonist/wizard_journeyman/proc/add_roundend_objective()
	switch(rand(1,100))
		if (1 to 60)
			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = owner
			objectives += escape_objective
		if (61 to 80)
			var/datum/objective/survive/survive_objective = new
			survive_objective.owner = owner
			objectives += survive_objective
		if (81 to 90)
			var/datum/objective/hijack/hijack_objective = new
			hijack_objective.owner = owner
			objectives += hijack_objective
		else
			var/datum/objective/martyr/martyr_objective = new
			martyr_objective.owner = owner
			objectives += martyr_objective

/datum/antagonist/wizard_journeyman/proc/send_to_lair()
	if (!owner)
		CRASH("Antag datum with no owner.")
	if (!owner.current)
		return
	if(!lair_exists)
		var/datum/map_template/wizard_apartment/new_level = new()
		if(!new_level.load_new_z())
			message_admins("The wizard apartment z-level failed to load, so journeymen have nowhere to spawn.")
			CRASH("Failed to initialize wizard apartment z-level!")
		lair_exists = TRUE
	if (!GLOB.journeymanstart.len)
		return
	owner.current.forceMove(pick(GLOB.journeymanstart))

/datum/antagonist/wizard_journeyman/proc/grant_hangover()
	if (!owner)
		CRASH("Antag datum with no owner.")
	var/mob/living/carbon/human/partygoer = owner.current
	if (!istype(partygoer))
		return
	partygoer.set_resting(TRUE, silent = TRUE)
	if (prob(50))
		partygoer.adjust_timed_status_effect(rand(30 SECONDS, 40 SECONDS), /datum/status_effect/drugginess)
	else
		partygoer.adjust_drunk_effect(rand(15, 25))
	partygoer.adjust_disgust(rand(5, 55))

/datum/antagonist/wizard_journeyman/proc/rename_wizard()
	set waitfor = FALSE

	var/wizard_name_first = pick(GLOB.wizard_first)
	var/wizard_name_second = pick(GLOB.wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	var/mob/living/wiz_mob = owner.current
	var/newname = sanitize_name(reject_bad_text(tgui_input_text(wiz_mob, "You are the [name]. Would you like to change your name to something else?", "Name change", randomname, MAX_NAME_LEN)))
	if (!newname)
		newname = randomname
	wiz_mob.fully_replace_character_name(wiz_mob.real_name, newname)

/datum/map_template/wizard_apartment
	name = "wizard's apartment"
	mappath = "_maps/templates/journeyman_apartment.dmm"

/area/wizard_apartment
	name = "Wizard's Apartment"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "wizards_den"
	static_lighting = TRUE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE
	network_root_id = "MAGIC_NET"

/obj/effect/landmark/start/wizard_journeyman
	name = "wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/obj/effect/landmark/start/wizard_journeyman/Initialize(mapload)
	..()
	GLOB.journeymanstart += loc
	return INITIALIZE_HINT_QDEL
