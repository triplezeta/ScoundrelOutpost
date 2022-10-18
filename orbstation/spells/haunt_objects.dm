/**
 * Haunt objects is a revenant spell and isn't suitable for casting by people who aren't revenants.
 * But I want to so here's a copy/pasted version which doesn't include the revenant parts.
 */
/datum/action/cooldown/spell/aoe/haunt_object
	name = "Call Poltergeists"
	desc = "Summons depraved spirits to possess nearby objects, causing them to attack the living. \
		Items closer to you are more likely to be haunted."
	icon_icon = 'icons/mob/actions/actions_revenant.dmi'
	sound = 'sound/magic/curse.ogg'
	button_icon_state = "r_haunt"
	cooldown_time = 30 SECONDS
	cooldown_reduction_per_rank = 2 SECONDS
	max_targets = 7
	aoe_radius = 5

/datum/action/cooldown/spell/aoe/haunt_object/get_things_to_cast_on(atom/center)
	var/list/things = list()
	for(var/obj/item/nearby_item in range(aoe_radius, center))
		// Don't throw around anchored things or dense things
		// (Or things not on a turf but I am not sure if range can catch that)
		if(nearby_item.anchored || nearby_item.density || !isturf(nearby_item.loc))
			continue
		// Don't throw abstract things
		if(nearby_item.item_flags & ABSTRACT)
			continue
		// Don't throw things we can't see
		if(nearby_item.invisibility >= SEE_INVISIBLE_LIVING)
			continue
		// Don't throw things that are already throwing themself
		if(istype(nearby_item.ai_controller, /datum/ai_controller/haunted))
			continue
		things += nearby_item

	return things

/datum/action/cooldown/spell/aoe/haunt_object/cast_on_thing_in_aoe(obj/item/victim, mob/living/simple_animal/revenant/caster)
	var/distance_from_caster = get_dist(get_turf(victim), get_turf(caster))
	var/chance_of_haunting = 150 * (1 / distance_from_caster)
	if(!prob(chance_of_haunting))
		return

	new /obj/effect/temp_visual/revenant(get_turf(victim))
	victim.AddComponent(/datum/component/haunted_item, \
		haunt_color = "#823abb", \
		haunt_duration = rand(1 MINUTES, 3 MINUTES), \
		aggro_radius = aoe_radius - 1, \
		spawn_message = span_revenwarning("[victim] begins to float and twirl into the air as it glows a ghastly purple!"), \
		despawn_message = span_revenwarning("[victim] falls back to the ground, stationary once more."), \
	)
