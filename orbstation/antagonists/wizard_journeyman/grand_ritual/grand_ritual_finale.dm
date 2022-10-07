/**
 * A big final event to run when you complete seven rituals
 */
/datum/grand_finale
	/// Friendly name for selection menu
	var/name
	/// Tooltip description for selection menu
	var/desc
	/// Prevent especially dangerous options from being chosen until we're fine with the round ending
	var/minimum_time = 0
	/// Override the rune invocation time
	var/ritual_invoke_time = 30 SECONDS
	/// Provide an extremely loud radio message when this one starts
	var/dire_warning = FALSE

/**
 * Actually do the thing.
 * Arguments
 * * invoker - The wizard casting this.
 */
/datum/grand_finale/proc/trigger(mob/living/invoker)
	// Do something cool.

/// Become the official Captain of the station
/datum/grand_finale/usurp
	name = "Usurpation"
	desc = "The ultimate prank! Rewrite time such that you have been Captain of this station the whole time."

/datum/grand_finale/usurp/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)] has replaced the Captain")
	var/list/former_captains = list()
	var/list/other_crew = list()
	for (var/mob/living/carbon/human/crewmate in GLOB.mob_list)
		if(!crewmate.mind)
			continue
		if (crewmate == invoker)
			continue
		var/job_title = crewmate.mind.assigned_role.title
		if (job_title == JOB_CAPTAIN)
			former_captains += crewmate
			demote_to_prison(crewmate)
			continue
		if (crewmate.stat != DEAD)
			other_crew += crewmate

	SEND_SOUND(world, sound('sound/magic/timeparadox2.ogg'))
	for(var/mob/living/victim as anything in GLOB.player_list)
		victim.Unconscious(3 SECONDS)
		to_chat(victim, span_notice("The world spins and dissolves. Your past flashes before your eyes, backwards.\n\
			Life strolls back into the ocean and shrinks into nothingness, planets explode into storms of solar dust, \
			the stars rush back to greet each other at the beginning of things and then... you snap back to the present. \n\
			Everything is just as it was and always has been. \n\n\
			A stray thought sticks in the forefront of your mind. \n\
			[span_hypnophrase("I'm so glad that [invoker.real_name] is our legally appointed Captain!")]"))

	dress_candidate(invoker)
	GLOB.data_core.manifest_modify(invoker.real_name, JOB_CAPTAIN, JOB_CAPTAIN)
	minor_announce("Captain [invoker.real_name] on deck!")

	// Enlist some crew to try and restore the natural order
	for (var/mob/living/carbon/human/former_captain as anything in former_captains)
		create_vendetta(former_captain.mind, invoker.mind)
	for (var/mob/living/carbon/human/random_crewmate as anything in other_crew)
		if (prob(10))
			create_vendetta(random_crewmate.mind, invoker.mind)

/**
 * Anyone who thought they were Captain is in for a nasty surprise, and won't be very happy about it
 */
/datum/grand_finale/usurp/proc/demote_to_prison(mob/living/carbon/human/former_captain)
	var/obj/effect/particle_effect/fluid/smoke/exit_poof = new(get_turf(former_captain))
	exit_poof.lifetime = 2 SECONDS

	former_captain.unequip_everything()
	if(isplasmaman(former_captain))
		former_captain.equipOutfit(/datum/outfit/plasmaman)
		former_captain.internal = former_captain.get_item_for_held_index(2)
	else
		former_captain.equipOutfit(/datum/outfit/job/assistant)

	GLOB.data_core.manifest_modify(former_captain.real_name, JOB_ASSISTANT, JOB_ASSISTANT)
	var/list/valid_turfs = list()
	// Used to be into prison but that felt a bit too mean
	for (var/turf/exile_turf as anything in get_area_turfs(/area/station/maintenance, subtypes = TRUE))
		if (isspaceturf(exile_turf))
			continue
		if (exile_turf.is_blocked_turf())
			continue
		valid_turfs += exile_turf
	do_teleport(former_captain, pick(valid_turfs), no_effects = TRUE)
	var/obj/effect/particle_effect/fluid/smoke/enter_poof = new(get_turf(former_captain))
	enter_poof.lifetime = 2 SECONDS

/**
 * Does some item juggling to try to dress you as both a Wizard and Captain without deleting any items you have bought.
 * ID, headset, and uniform are forcibly replaced. Other slots are only filled if unoccupied.
 * We could forcibly replace shoes and gloves too but people might miss their insuls or... meown shoes?
 */
/datum/grand_finale/usurp/proc/dress_candidate(mob/living/carbon/human/invoker)
	// Won't be needing these
	var/obj/id = invoker.get_item_by_slot(ITEM_SLOT_ID)
	QDEL_NULL(id)
	var/obj/headset = invoker.get_item_by_slot(ITEM_SLOT_EARS)
	QDEL_NULL(headset)
	// We're about to take off your pants so those are going to fall out
	var/obj/item/pocket_L = invoker.get_item_by_slot(ITEM_SLOT_LPOCKET)
	var/obj/item/pocket_R = invoker.get_item_by_slot(ITEM_SLOT_RPOCKET)
	// In case we try to put a PDA there
	var/obj/item/belt = invoker.get_item_by_slot(ITEM_SLOT_BELT)
	belt?.moveToNullspace()

	var/obj/pants = invoker.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	QDEL_NULL(pants)
	invoker.equipOutfit(/datum/outfit/job/wizard_captain)
	// And put everything back!
	equip_to_slot_then_hands(invoker, ITEM_SLOT_BELT, belt)
	equip_to_slot_then_hands(invoker, ITEM_SLOT_LPOCKET, pocket_L)
	equip_to_slot_then_hands(invoker, ITEM_SLOT_RPOCKET, pocket_R)

/// Tries to equip something into an inventory slot, then hands, then the floor.
/datum/grand_finale/usurp/proc/equip_to_slot_then_hands(mob/living/carbon/human/invoker, slot, obj/item/item)
	if(!item)
		return
	if(!invoker.equip_to_slot_if_possible(item, slot, disable_warning = TRUE))
		invoker.put_in_hands(item)

/// They are not going to take this lying down.
/datum/grand_finale/usurp/proc/create_vendetta(datum/mind/aggrieved_crewmate, datum/mind/new_captain)
	aggrieved_crewmate.add_antag_datum(/datum/antagonist/wizard_prank_vendetta)
	var/datum/antagonist/wizard_prank_vendetta/antag_datum = aggrieved_crewmate.has_antag_datum(/datum/antagonist/wizard_prank_vendetta)
	var/datum/objective/assassinate/wizard_murder = new
	wizard_murder.owner = aggrieved_crewmate
	wizard_murder.target = new_captain
	wizard_murder.explanation_text = "Kill [new_captain.current.name], the one who did this."
	antag_datum.objectives += wizard_murder

	to_chat(aggrieved_crewmate.current, span_warning("No! This... isn't right!"))
	aggrieved_crewmate.announce_objectives()

/// An outfit which replaces parts of a wizard's clothes with captain's clothes but keeps the robes
/datum/outfit/job/wizard_captain
	name = "Captain (Wizard Transformation)"
	jobtype = /datum/job/captain
	id = /obj/item/card/id/advanced/gold
	id_trim = /datum/id_trim/job/captain
	uniform = /obj/item/clothing/under/rank/captain/parade
	belt = /obj/item/modular_computer/tablet/pda/heads/captain
	ears = /obj/item/radio/headset/heads/captain/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/captain
	shoes = /obj/item/clothing/shoes/laceup
	accessory = /obj/item/clothing/accessory/medal/gold/captain
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/station_charter = 1,
		)
	box = null

/**
 * Antag datum to give to people who want to kill the wizard.
 * This doesn't preclude other people choosing to want to kill the wizard, just these people are rewarded for it.
 */
/datum/antagonist/wizard_prank_vendetta
	name = "\improper Wizard Prank Victim"
	roundend_category = "wizard prank victims"
	show_in_antagpanel = FALSE
	antagpanel_category = "Other"
	show_name_in_check_antagonists = TRUE
	count_against_dynamic_roll_chance = FALSE
	silent = TRUE

/// Dress the crew as magical clowns
/datum/grand_finale/clown
	name = "Jubilation"
	desc = "The ultimate prank! Rewrite time so that everyone went to clown college! Now they'll prank each other for you!"

/// Give everyone magic items
/datum/grand_finale/magic
	name = "Evolution"
	desc = "The ultimate prank! Give the crew their own magic, they'll surely realise that right and wrong have no meaning when you hold ultimate power!"

/datum/grand_finale/magic/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)] summoned magic")
	summon_magic(survivor_probability = 20) // Wow, this one was easy!

/// Open all of the doors
/datum/grand_finale/all_access
	name = "Connection"
	desc = "The ultimate prank! Unlock every single door that they have! Nobody will be able to keep you out now, or anyone else for that matter!"

/datum/grand_finale/all_access/trigger(mob/living/carbon/human/invoker)
	message_admins("[key_name(invoker)] removed all door access requirements")
	for(var/obj/machinery/door/target_door in GLOB.machines)
		if(is_station_level(target_door.z))
			target_door.req_access = list()
			INVOKE_ASYNC(target_door, /obj/machinery/door/airlock.proc/open)
	priority_announce("AULIE OXIN FIERA!!", null, 'sound/magic/knock.ogg', sender_override = "[invoker.real_name]")

/// Completely transform the station
/datum/grand_finale/midas
	name = "Transformation"
	desc = "The ultimate prank! Turn their precious station into something much MORE precious, materially speaking!"
	var/static/list/permitted_transforms = list( // Non-dangerous only
		/datum/dimension_theme/gold,
		/datum/dimension_theme/meat,
		/datum/dimension_theme/glass,
		/datum/dimension_theme/disco)
	var/datum/dimension_theme/chosen_theme

// I sure hope this doesn't have performance implications
/datum/grand_finale/midas/trigger(mob/living/carbon/human/invoker)
	var/theme_path = pick(permitted_transforms)
	chosen_theme = new theme_path()
	var/turf/start_turf = get_turf(invoker)
	var/greatest_dist = 0
	var/list/turfs_to_transform = list()
	for (var/turf/transform_turf as anything in GLOB.station_turfs)
		if (!chosen_theme.can_convert(transform_turf))
			continue
		var/dist = get_dist(start_turf, transform_turf)
		if (dist > greatest_dist)
			greatest_dist = dist
		if (!turfs_to_transform["[dist]"])
			turfs_to_transform["[dist]"] = list()
		turfs_to_transform["[dist]"] += transform_turf

	if (chosen_theme.can_convert(start_turf))
		chosen_theme.apply_theme(start_turf)

	for (var/iterator in 1 to greatest_dist)
		if(!turfs_to_transform["[iterator]"])
			continue
		addtimer(CALLBACK(src, .proc/transform_area, turfs_to_transform["[iterator]"]), (5 SECONDS) * iterator)

/datum/grand_finale/midas/proc/transform_area(list/turfs)
	for (var/turf/transform_turf as anything in turfs)
		if (!chosen_theme.can_convert(transform_turf))
			continue
		chosen_theme.apply_theme(transform_turf)

/// Kill yourself and probably a bunch of other people
/datum/grand_finale/armageddon
	name = "Annihilation"
	desc = "This crew have offended you beyond the realm of pranks. Make the ultimate sacrifice to teach them a lesson your elders can really respect. \
		YOU WILL NOT SURVIVE THIS."
	minimum_time = 90 MINUTES
	ritual_invoke_time = 60 SECONDS // Really give the crew some time to interfere with this one
	dire_warning = TRUE
