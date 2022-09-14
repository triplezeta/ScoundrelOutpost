#define CUSTOM_OBJECTIVE_MAX_LENGTH 300

/datum/uplink_category/contract
	name = "Contract Negotiation"
	weight = -3 // just above discount items (because those are apparently hard-coded to be at the bottom)

/datum/uplink_item/contract
	category = /datum/uplink_category/contract
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/contract/freeform
	name = "Renegotiate Contract"
	desc = "Opt out of conventional objectives and forge your own path forward in pursuit of a custom goal. \
	Be warned that you will no longer be able to earn telecrystals. There is no turning back."
	item = /obj/effect/gibspawner/generic
	surplus = 0
	cost = 0
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	purchase_log_vis = FALSE

	/// The default explanation of the freeform objective, which can be customized by the traitor.
	var/default_objective_text = "Sow fear and discord as a free agent of the Syndicate."

/datum/uplink_item/contract/freeform/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	var/datum/antagonist/traitor/traitor_datum
	for(var/datum/antagonist/antag in user.mind.antag_datums)
		if(istype(antag, /datum/antagonist/traitor))
			traitor_datum = antag
			break
	// Non-traitors can't use this for obvious reasons :v
	if(!traitor_datum)
		return source //For log icon

	for(var/datum/objective/primary_objective in traitor_datum.objectives)
		if(istype(primary_objective, /datum/objective/custom) || istype(primary_objective, /datum/objective/traitor_final)) // prevents overriding pre-existing custom objectives or final objectives
			to_chat(user, span_warning("Request denied. The terms of your current contract are non-negotiable."))
			return source

	// Allow the traitor to write down a custom objective if they so wish.
	var/custom_objective_text = tgui_input_text(user, "Write down the terms of your new contract:", "Custom Objective", default_objective_text, CUSTOM_OBJECTIVE_MAX_LENGTH)
	if(!custom_objective_text) // such as if the user hits "cancel"
		return source

	log_traitor("[key_name(user)] opted out of uplink objectives and chose a custom objective: [custom_objective_text]")
	message_admins("[ADMIN_LOOKUPFLW(user)] has chosen a custom traitor objective: [span_syndradio("[custom_objective_text]")] | [ADMIN_SYNDICATE_REPLY(user)]")

	for(var/client/admin_client in GLOB.admins)
		if(admin_client.prefs.toggles & SOUND_ADMINHELP)
			SEND_SOUND(admin_client, sound('sound/effects/gong.ogg'))

	// Let's fail all the objectives on the uplink to get them out of the way.
	for(var/datum/traitor_objective/active_objective as anything in uplink_handler.active_objectives)
		active_objective.fail_objective(penalty_cost = 0)
	for(var/datum/traitor_objective/potential_objective as anything in uplink_handler.potential_objectives)
		potential_objective.fail_objective()

	// The traitor can no longer take new objectives. Displays "you are locked out of objectives" on the objectives screen.
	uplink_handler.maximum_potential_objectives = 0

	// Replace those normal primary objectives with a special objective that automatically succeeds
	user.playsound_local(get_turf(user), 'sound/traitor/final_objective.ogg', vol = 100, vary = FALSE, channel = CHANNEL_TRAITOR)
	traitor_datum.objectives.Cut()
	var/datum/objective/custom/custom_objective = new /datum/objective/custom()
	custom_objective.explanation_text = custom_objective_text
	custom_objective.owner = traitor_datum.owner
	custom_objective.completed = TRUE
	traitor_datum.objectives += custom_objective
	to_chat(user, span_boldwarning("Your request has been received. Until further notice, these are the new terms of your contract. Good luck, agent."))
	traitor_datum.owner.announce_objectives()
	return source

#undef CUSTOM_OBJECTIVE_MAX_LENGTH
