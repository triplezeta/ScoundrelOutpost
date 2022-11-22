/**
 * ## Staggered AOE spells
 *
 * A spell that iterates over atoms near the caster and casts a spell on them.
 * Calls cast_on_thing_in_aoe on all atoms returned by get_things_to_cast_on by default.
 * Atoms nearer the caster are affected sooner than ones further away.
 */
/datum/action/cooldown/spell/aoe_staggered
	/// Period to wait between each 'wave'
	var/stagger_period = 0.5 SECONDS
	/// The radius of the aoe.
	var/aoe_radius = 7

// At this point, cast_on == owner. Either works.
// Don't extend this for your spell! Look at cast_on_thing_in_aoe.
/datum/action/cooldown/spell/aoe_staggered/cast(atom/cast_on)
	. = ..()
	// Get every atom around us to our aoe cast on
	var/list/atom/things_to_cast_on = get_things_to_cast_on(cast_on)
	SEND_SIGNAL(src, COMSIG_SPELL_AOE_ON_CAST, things_to_cast_on, cast_on)

	var/start_turf = get_turf(cast_on)
	var/list/atom/staggered_things_to_cast_on = list()

	// Now go through and cast our spell where applicable
	for (var/thing_to_target in things_to_cast_on)
		var/turf/thing_turf = get_turf(thing_to_target)
		var/dist = get_dist(start_turf, thing_turf)
		if (!staggered_things_to_cast_on["[dist]"])
			staggered_things_to_cast_on["[dist]"] = list()
		staggered_things_to_cast_on["[dist]"] += thing_to_target

	for (var/iterator in 1 to aoe_radius)
		if(!staggered_things_to_cast_on["[iterator]"])
			continue
		addtimer(CALLBACK(src, PROC_REF(cast_wave), staggered_things_to_cast_on["[iterator]"], cast_on, iterator), stagger_period * iterator)

/**
 * Gets a list of atoms around [center] that are within range and going to be affected by our aoe.
 * You should override this on a subtype basis to change what your spell affects.
 *
 * For example, if you want to only cast on atoms in view instead of range.
 * Or, if you only want living mobs in the list.
 *
 * When using range / view, it's handy to remember the byond optimization they have by casting to an atom type.
 *
 * Returns a list of atoms.
 */
/datum/action/cooldown/spell/aoe_staggered/proc/get_things_to_cast_on(atom/center)
	RETURN_TYPE(/list)

	var/list/things = list()
	// Default behavior is to get all atoms in range, center and owner not included.
	for(var/atom/nearby_thing in range(aoe_radius, center))
		if(nearby_thing == owner || nearby_thing == center)
			continue
		things += nearby_thing

	return things

// Calls cast_on_thing_in_aoe on everything at a certain range from the caster
// You shouldn't really need to override this either, only cast_on_thing_in_aoe
/datum/action/cooldown/spell/aoe_staggered/proc/cast_wave(list/things_at_range, atom/caster, range)
	for (var/thing_to_target in things_at_range)
		cast_on_thing_in_aoe(thing_to_target, caster, range)

/**
 * Actually cause effects on the thing in our aoe.
 * Override this for your spell! Not cast().
 *
 * Arguments
 * * victim - the atom being affected by our aoe
 * * caster - the mob who cast the aoe
 * * range - distance the target is from the start point
 */
/datum/action/cooldown/spell/aoe_staggered/proc/cast_on_thing_in_aoe(atom/victim, atom/caster, range)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("[type] did not implement cast_on_thing_in_aoe and either has no effects or implemented the spell incorrectly.")
