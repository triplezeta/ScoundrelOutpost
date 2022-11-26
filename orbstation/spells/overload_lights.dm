/**
 * Overload lights is a revenant spell and isn't suitable for casting by people who aren't revenants.
 * But I want to so here's a copy/pasted version which doesn't include the revenant parts.
 */
/datum/action/cooldown/spell/aoe/overload_lights
	name = "Power Surge"
	desc = "Directs a large amount of magical power into nearby electrical lights, causing lights to shock those nearby."
	icon_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "overload_lights"
	cooldown_time = 30 SECONDS
	cooldown_reduction_per_rank = 2 SECONDS
	aoe_radius = 5

	/// The range the shocks from the lights go
	var/shock_range = 2
	/// The damage the shocks from the lights do
	var/shock_damage = 15

/// We only care about turfs
/datum/action/cooldown/spell/aoe/overload_lights/get_things_to_cast_on(atom/center)
	var/list/things = list()
	for(var/turf/nearby_turf in range(aoe_radius, center))
		things += nearby_turf

	return things

/datum/action/cooldown/spell/aoe/overload_lights/cast_on_thing_in_aoe(turf/victim, mob/living/caster)
	for(var/obj/machinery/light/light in victim)
		if(!light.on)
			continue

		light.flicker()
		light.visible_message(span_boldwarning("[light] suddenly flares brightly and begins to spark!"))
		var/datum/effect_system/spark_spread/light_sparks = new /datum/effect_system/spark_spread()
		light_sparks.set_up(4, 0, light)
		light_sparks.start()
		new /obj/effect/temp_visual/revenant(get_turf(light))
		addtimer(CALLBACK(src, PROC_REF(overload_shock), light, caster), 2 SECONDS)

/datum/action/cooldown/spell/aoe/overload_lights/proc/overload_shock(obj/machinery/light/to_shock, mob/living/caster)
	flick("[to_shock.base_state]2", to_shock)
	for(var/mob/living/carbon/human/human_mob in view(shock_range, to_shock))
		if(human_mob == caster)
			continue
		to_shock.Beam(human_mob, icon_state = "purple_lightning", time = 0.5 SECONDS)
		if(!human_mob.can_block_magic(antimagic_flags))
			human_mob.electrocute_act(shock_damage, to_shock, flags = SHOCK_NOGLOVES)

		do_sparks(4, FALSE, human_mob)
		playsound(human_mob, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
	if(prob(40))
		to_shock.break_light_tube()
