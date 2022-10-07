/// Number of times you need to cast on the rune to complete it
#define GRAND_RUNE_INVOKES_TO_COMPLETE 3
/// Returns true if you're a wizard or a journeyman
/// You will probably never have both of these at the same time but if a big wizard wants to finish the rune of a small one who am I to say they can't?
#define IS_WIZARD_OR_JOURNEYMAN(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/wizard_journeyman || mob?.mind?.has_antag_datum(/datum/antagonist/wizard)))
/// Base time to take to invoke one stage of the rune. This is done three times to complete the rune.
#define BASE_INVOKE_TIME 7 SECONDS
/// Time to add on to each step every time a previous rune is completed.
#define ADD_INVOKE_TIME 2 SECONDS
/// The crew will start being warned every time a rune is created after this many invocations.
#define CREW_WARNING_POTENCY 3
/// The crew will get a louder warning when this level of rune is created
#define CREW_URGENT_WARNING_POTENCY 6

/**
 * Magic rune used in the grand ritual.
 * A wizard sits themselves on this thing and waves their hands for a while shouting silly words.
 * Then something (usually bad) happens.
 */
/obj/effect/grand_rune
	name = "grand rune"
	desc = "A flowing circle of shapes and runes is etched into the floor, the lines twist and move before your eyes."
	icon = 'orbstation/icons/effects/rune.dmi'
	icon_state = "rune"
	pixel_x = -28
	pixel_y = -33
	anchored = TRUE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	/// How many prior grand rituals have been completed?
	var/potency = 0
	/// Time to take per invocation of rune.
	var/invoke_time = BASE_INVOKE_TIME
	/// Prevent ritual spam click.
	var/is_in_use = FALSE
	/// Number of times this rune has been cast
	var/times_invoked = 0
	/// Magic words you say to invoke the ritual
	var/list/magic_words = list()
	/**
	 * Possible things you can yell when invoking the rune. Wizards are silly, so... so are these.
	 * It was actually really hard to think of any three-part incantations which weren't dumb jokes.
	 * Please do contribute more if you think of some.
	 */
	var/static/list/possible_magic_words = list(
		list("Abra...", "Cadabra...", "Alakazam!"),
		list("Bibbity!", "Bobbity!", "Boo!"),
		list("Micrato", "Raepij", "Sathonich!"),
		list("Sim!", "Sala!", "Bim!"),
		list("Hocus Pocus!", "Flim Flam!", "Wabbajack!"),
		list("Esaelp!", "Ouy Knaht!", "Em Esucxe!!"),
		list("Quas!", "Wex!", "Exort!"),
		list("Ten!", "Chi!", "Jin!"),
		list("Fus", "Roh", "Dah!!"),
		list("Y-abbaa", "Dab'Bah", "Doom!!"),
		list("Azarath!", "Metrion!", "Zinthos!!"),
		list("Klaatu!", "Barada!", "Nikto!!"),
		list("Drivaron Ple'ez!", "Shabadoobie!", "Henshin!!"),
		list("Bish", "Bash", "Bosh!"),
		list("Halev Li'af!", "Epizadh!", "Free!!"),
		list("*scream", "*scream", "*scream"),
		list("One and a...", "Two and a...", "One Two Three Four!!"),
		list("Let expanse contract!", "Let eon become instant!", "Throw wide the gates!!"),
		list("The arcane is mine to command!", "Yawn wide, ever-hungering void!", "Behold, a sorcerer of eld!!"),
		list("Seven shadows cast, seven fates foretold!", "Let their words echo in your empty soul!", "Ruination is come!!"),
		list("Swiftcast! Hastega! Abjurer's Ward II! Extend IV! Tenser's Advanced Enhancement! Protection from Good! Enhance Effect III! Arcane Re...",
			"...inforcement IV! Turn Vermin X! Protection from Evil II! Mage's Shield! Venerious's Mediocre Enhancement II! Expand Power! Banish Hu...",
			"...nger II! Protection from Neutral! Surecastaga! Refresh! Refresh II! Sharpcast X! Aetherial Manipulation! Ley Line Absorption! Invoke Grand Ritual!!"),
		list("git checkout origin master", "git reset --hard HEAD~2", "git push origin master --force!!",)
	)

// Prepare magic words and hide from silicons
/obj/effect/grand_rune/Initialize(mapload, potency = 0)
	. = ..()
	src.potency = potency
	invoke_time = (BASE_INVOKE_TIME) + (potency * (ADD_INVOKE_TIME))
	magic_words = pick(possible_magic_words)
	var/image/silicon_image = image(icon = 'icons/effects/eldritch.dmi', icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "heretic_rune", silicon_image)
	announce_rune()

/// I cast Summon Security
/obj/effect/grand_rune/proc/announce_rune()
	var/area/created_area = get_area(src)
	if (potency >= CREW_URGENT_WARNING_POTENCY)
		priority_announce("Major anomalous fluctuations to local spacetime detected in: [created_area.name].", "Anomaly Alert")
		return
	if (potency >= CREW_WARNING_POTENCY)
		priority_announce("Unusual anomalous energy fluctuations detected in: [created_area.name].", "Anomaly Alert")
		return

#undef CREW_WARNING_POTENCY
#undef CREW_URGENT_WARNING_POTENCY

/obj/effect/grand_rune/examine(mob/user)
	. = ..()
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		. += span_notice("It's power seems to have been expended.")
		return
	if(!IS_WIZARD_OR_JOURNEYMAN(user))
		return
	. += span_notice("Invoke this rune [GRAND_RUNE_INVOKES_TO_COMPLETE - times_invoked] more times to complete the ritual.")

/obj/effect/grand_rune/can_interact(mob/living/user)
	. = ..()
	if(!.)
		return
	if(!IS_WIZARD_OR_JOURNEYMAN(user))
		return FALSE
	if(is_in_use)
		return FALSE
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		return FALSE
	return TRUE

/obj/effect/grand_rune/interact(mob/living/user)
	. = ..()
	INVOKE_ASYNC(src, .proc/invoke_rune, user)
	return TRUE

/// Actually does the whole invoking thing
/obj/effect/grand_rune/proc/invoke_rune(mob/living/user)
	is_in_use = TRUE
	add_channel_effect(user)
	user.balloon_alert(user, "invoking rune...")
	if(!do_after(user, invoke_time, src))
		remove_channel_effect(user)
		user.balloon_alert(user, "interrupted!")
		is_in_use = FALSE
		return

	times_invoked++
	user.say(magic_words[times_invoked], forced = "grand ritual invocation")
	remove_channel_effect(user)

	for(var/obj/machinery/light/light in orange(4, src.loc))
		light.flicker() // ooOOOOoooOOoooOOo

	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		on_invocation_complete(user)
		return
	flick("flash", src)
	playsound(src,'sound/magic/staff_animation.ogg', 75, TRUE)
	INVOKE_ASYNC(src, .proc/invoke_rune, user)

/// Add special effects for casting a spell, basically you glow and hover in the air.
/obj/effect/grand_rune/proc/add_channel_effect(mob/living/user)
	user.AddElement(/datum/element/forced_gravity, 0)
	user.add_filter("teleport_glow", 2, list("type" = "outline", "color" = "#de3aff48", "size" = 2))

/// Remove special effects for casting a spell
/obj/effect/grand_rune/proc/remove_channel_effect(mob/living/user)
	user.RemoveElement(/datum/element/forced_gravity, 0)
	user.remove_filter("teleport_glow")

/obj/effect/grand_rune/proc/get_invoke_time()
	return  (BASE_INVOKE_TIME) + (potency * (ADD_INVOKE_TIME))

/// Called when you actually finish the damn thing
/obj/effect/grand_rune/proc/on_invocation_complete(mob/living/user)
	is_in_use = FALSE
	playsound(src,'sound/magic/staff_change.ogg', 75, TRUE)
	INVOKE_ASYNC(src, .proc/summon_round_event, user) // Running the event sleeps
	trigger_side_effects()
	tear_reality()
	SEND_SIGNAL(src, COMSIG_GRAND_RUNE_COMPLETE)
	flick("activate", src)
	addtimer(CALLBACK(src, .proc/remove_rune), 6)

/obj/effect/grand_rune/proc/remove_rune()
	new /obj/effect/decal/cleanable/grand_remains(get_turf(src))
	qdel(src)

/// Triggers some form of event somewhere on the station
/obj/effect/grand_rune/proc/summon_round_event(mob/living/user)
	var/list/possible_events = list()
	for (var/event_path as anything in subtypesof(/datum/grand_event))
		var/datum/grand_event/event = new event_path()
		if (!event.is_valid_event(potency))
			continue
		possible_events += event

	var/datum/grand_event/final_event = pick(possible_events)
	final_event.trigger_event(user)

/// Applies some local side effects to the area
/obj/effect/grand_rune/proc/trigger_side_effects(mob/living/user)
	if (potency == 0) // Not on the first one
		return
	var/list/possible_effects = list()
	for (var/effect_path as anything in subtypesof(/datum/grand_side_effect))
		var/datum/grand_side_effect/effect = new effect_path()
		if (!effect.can_trigger(loc))
			continue
		possible_effects += effect

	var/datum/grand_side_effect/final_effect = pick(possible_effects)
	to_chat(world, "triggering [final_effect]")
	final_effect.trigger(potency, loc, user)

/**
 * Invoking the ritual spawns up to three reality tears based on potency.
 * Each of these has a 50% chance to spawn already expended.
 * I think this is fun flavour (the wizard is breaking local reality), and adds cross-antagonist interactivity.
 */
/obj/effect/grand_rune/proc/tear_reality()
	var/max_tears = 0
	switch(potency)
		if(0 to 2)
			max_tears = 1
		if (3 to 5)
			max_tears = 2
		if (6 to 7)
			max_tears = 3

	var/to_create = rand(0, max_tears)
	if (to_create == 0)
		return
	var/created = 0
	var/location_sanity = 0
	// Copied from the influences manager, but we don't want to obey the cap on influences per heretic.
	while(created < to_create && location_sanity < 100)
		var/turf/chosen_location = get_safe_random_station_turf()

		// We don't want them close to each other - at least 1 tile of seperation
		var/list/nearby_things = range(1, chosen_location)
		var/obj/effect/heretic_influence/what_if_i_have_one = locate() in nearby_things
		var/obj/effect/visible_heretic_influence/what_if_i_had_one_but_its_used = locate() in nearby_things
		if(what_if_i_have_one || what_if_i_had_one_but_its_used)
			location_sanity++
			continue

		var/obj/effect/heretic_influence/new_influence = new(chosen_location)
		if (prob(50))
			new_influence.after_drain()
		created++

#undef GRAND_RUNE_INVOKES_TO_COMPLETE
#undef IS_WIZARD_OR_JOURNEYMAN

#undef BASE_INVOKE_TIME
#undef ADD_INVOKE_TIME

/// Spawned when we are done with the rune
/obj/effect/decal/cleanable/grand_remains
	name = "circle of ash"
	desc = "Looks like someone's been drawing shapes with ash on the ground."
	icon = 'orbstation/icons/effects/rune.dmi'
	icon_state = "burned"
	pixel_x = -28
	pixel_y = -34
	anchored = TRUE
	mergeable_decal = FALSE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	clean_type = CLEAN_TYPE_HARD_DECAL
	layer = SIGIL_LAYER


/obj/effect/debug_rune
	name = "grand rune"
	desc = "A flowing circle of shapes and runes is etched into the floor, the lines twist and move before your eyes."
	icon = 'orbstation/icons/effects/rune.dmi'
	icon_state = "rune"
	pixel_x = -28
	pixel_y = -33
	anchored = TRUE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER

/obj/effect/debug_rune/interact(mob/living/user)
	. = ..()

	var/datum/grand_finale/midas/usuper = new()
	usuper.trigger(user)

	return TRUE
