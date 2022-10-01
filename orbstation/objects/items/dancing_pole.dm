
/datum/crafting_recipe/dancing_pole
	name = "Dancing Pole"
	result = /obj/structure/dancing_pole
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/iron = 3,
				/obj/item/stack/rods = 8)
	category = CAT_MISC

/obj/structure/dancing_pole
	name = "Dancing Pole"
	desc = "Show off your moves!"
	icon = 'orbstation/icons/obj/dancing_pole.dmi'
	icon_state = "pole"
	plane = GAME_PLANE_UPPER
	anchored = FALSE
	density = TRUE
	var/emagged = FALSE
	var/datum/weakref/dancer = null

/obj/structure/dancing_pole/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/dancing_pole/AltClick(mob/living/carbon/human/user)
	. = ..()
	set_anchored(!anchored)
	to_chat(user, span_notice("You [anchored ? null : "un"]lock the dancing pole."))

/obj/structure/dancing_pole/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if (emagged)
		return
	emagged = TRUE
	do_sparks(5, FALSE, src)

#define DANCE_OFFSET 7

/obj/structure/dancing_pole/attack_hand(mob/living/carbon/human/user, list/modifiers)
	if (!anchored)
		balloon_alert(user, "pole isn't anchored")
		return
	if (dancer?.resolve())
		balloon_alert(user, "already occupied")
		return

	dance(user)

/**
 * The user will dance for 10 seconds, as long as they don't try to do anything else with their hands.
 * Letting go of the pole (or being shoved) will throw them in a random direction to dismount.
 * If emagged they will dance faster and catch fire after a little while.
 * If they dance to completion, everyone who can see it (including themselves) will get happy.
 * This also gives you the exercise buff which makes you resistant to heart attacks!
 * Arguments
 * * user - Human who is using the pole.
 */
/obj/structure/dancing_pole/proc/dance(mob/living/carbon/human/user)
	var/last_loc = user.loc
	user.forceMove(loc)
	var/prev_plane = user.plane
	user.plane = GAME_PLANE_UPPER
	var/prev_y = user.pixel_y
	user.pixel_y = DANCE_OFFSET
	spin_dancer(user)

	dancer = WEAKREF(user)
	START_PROCESSING(SSobj, src)

	user.Immobilize(10 SECONDS)
	user.visible_message("<B>[user] is [get_brag_message()]!</B>")

	if (emagged)
		addtimer(CALLBACK(src, .proc/overdrive, user), 5 SECONDS)

	if (!do_after(user, 10 SECONDS, src))
		user.visible_message("<B>[user] slips off the pole!</B>")
		user.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1, 10), rand(1, 10))
		user.Stun(10 SECONDS)
	else
		user.SpinAnimation(7,1)
		user.apply_status_effect(/datum/status_effect/exercised)
		for (var/mob/living/audience in view(7, src))
			audience.add_mood_event("performance", /datum/mood_event/dance_audience)

		if (emagged)
			user.visible_message("<B>[user] spins out of control!</B>")
			user.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1, 10), rand(1, 10))
			user.Knockdown(3 SECONDS)
		else
			user.forceMove(last_loc)
			user.emote("bow")

	user.plane = prev_plane
	user.pixel_y = prev_y
	STOP_PROCESSING(SSobj, src)
	dancer = null

/// Spins the current dancer every 2 seconds.
/obj/structure/dancing_pole/process()
	var/mob/living/current_dancer = dancer?.resolve()
	if (!current_dancer)
		return
	if (!istype(current_dancer))
		return
	spin_dancer(current_dancer)

/// Returns a funny message to show to everyone when you start dancing.
/obj/structure/dancing_pole/proc/get_brag_message()
	if (emagged)
		return pick("pushing it to the limit","going into overdrive","busting it down","activating the spin cycle", "really feeling it")
	return pick("showing off","demonstrating some moves","putting on a show","playing to the crowd", "holding a passionate performance")

/**
 * Applies a spin animation to the current dancer for 2 seconds. Spin is faster if emagged.
 * Arguments
 * * current_dancer - Mob who is using the pole.
 */
/obj/structure/dancing_pole/proc/spin_dancer(mob/living/current_dancer)
	current_dancer.spin(2 SECONDS, emagged ? 1 : 2)

/**
 * Sets the current dancer on fire halfway through the dance, if they are still the person who started dancing 5 seconds ago.
 * Arguments
 * * victim - Person who was dancing 5 seconds ago, may not be the current dancer if they got off the pole.
 */
/obj/structure/dancing_pole/proc/overdrive(mob/living/victim)
	var/mob/living/current_dancer = dancer?.resolve()
	if (!current_dancer)
		return
	if (!istype(current_dancer))
		return
	if (current_dancer != victim)
		return
	var/alert_message = pick("is burning with passion", "sets the dance floor on fire", "is so hot right now", "is maybe dancing a little too hard")
	current_dancer.visible_message("<B>[current_dancer] [alert_message]!</B>")
	current_dancer.adjust_fire_stacks(4)
	current_dancer.ignite_mob()

/// Adds contextual screentips
/obj/structure/dancing_pole/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if (!anchored)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Anchor"
		return CONTEXTUAL_SCREENTIP_SET

	if (!held_item)
		context[SCREENTIP_CONTEXT_LMB] = "Dance"
	else if (istype(held_item, /obj/item/card/emag))
		context[SCREENTIP_CONTEXT_LMB] = "Sabotage"
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Unanchor"
	return CONTEXTUAL_SCREENTIP_SET

/datum/mood_event/dance_audience
	description = "That was a great dance!"
	mood_change = 2
	timeout = 5 MINUTES
