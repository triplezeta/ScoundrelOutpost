GLOBAL_LIST_EMPTY(journeymanstart)

/datum/job/wizard_journeyman
	title = "Wizard Journeyman"
	faction = ROLE_WIZARD

/datum/antagonist/wizard_journeyman
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
	var/strip = TRUE //strip before equipping
	var/allow_rename = TRUE
	var/outfit_type = /datum/outfit/wizard
	var/wiz_age = WIZARD_AGE_MIN /* Wizards by nature cannot be too young. */
	show_to_ghosts = TRUE

/datum/antagonist/wizard_journeyman/on_gain()
	equip_wizard()
	if(give_objectives)
		create_objectives()
	if(move_to_lair)
		send_to_lair()
	. = ..()
	if(allow_rename)
		rename_wizard()

/datum/antagonist/wizard_journeyman/proc/send_to_lair()
	if(!owner)
		CRASH("Antag datum with no owner.")
	if(!owner.current)
		return
	if(!GLOB.journeymanstart.len)
		return
	owner.current.forceMove(pick(GLOB.journeymanstart))

/datum/antagonist/wizard_journeyman/proc/create_objectives()

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
