/**
 * Spawns goliath tentacles in an expanding circle around you.
 */
/datum/action/cooldown/spell/aoe_staggered/tentacle_burst
	name = "Tentacle Burst"
	desc = "Conjure a wave of tentacles from the ground to grapple your foes."
	background_icon_state = "bg_ecult"
	icon_icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	button_icon_state = "goliath"
	sound = 'sound/magic/demon_attack1.ogg'
	aoe_radius = 5
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 10 SECONDS

/datum/action/cooldown/spell/aoe_staggered/tentacle_burst/get_things_to_cast_on(atom/center)
	var/list/things = list()
	for (var/turf/nearby_turf in view(aoe_radius, center))
		if (nearby_turf == center)
			continue
		if (nearby_turf.density)
			continue
		things += nearby_turf
	return things

/datum/action/cooldown/spell/aoe_staggered/tentacle_burst/cast_on_thing_in_aoe(turf/target_loc, atom/caster, range)
	new /obj/effect/temp_visual/goliath_tentacle/magic(target_loc, caster)

/// Extended goliath tentacle for spell modification
/obj/effect/temp_visual/goliath_tentacle/magic
	name = "conjured tentacle"
	/// Time to grab the target for
	var/disable_time = 6 SECONDS

// Override targetting to not grab caster
/obj/effect/temp_visual/goliath_tentacle/magic/trip()
	var/latched = FALSE
	for(var/mob/living/target in loc)
		if((!QDELETED(spawner) && target == spawner) || target.stat == DEAD)
			continue
		visible_message(span_danger("[src] grabs hold of [target]!"))
		target.Knockdown(disable_time)
		target.Stun(disable_time)
		target.adjustBruteLoss(rand(10,15))
		buckle_mob(target, TRUE)
		latched = TRUE

	if(!latched)
		retract()
	else
		deltimer(timerid)
		timerid = addtimer(CALLBACK(src, PROC_REF(retract)), disable_time, TIMER_STOPPABLE)
