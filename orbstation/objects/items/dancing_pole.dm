
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

	var/last_loc = user.loc
	user.forceMove(loc)
	var/prev_plane = user.plane
	user.plane = GAME_PLANE_UPPER
	var/prev_y = user.pixel_y
	user.pixel_y = DANCE_OFFSET
	user.spin(2 SECONDS, 1)

	dancer = WEAKREF(user)
	START_PROCESSING(SSobj, src)

	user.Immobilize(10 SECONDS)
	var/bragmessage = pick("pushing it to the limit","going into overdrive","busting it down","activating the spin cycle", "really feeling it","putting on a show")
	user.visible_message("<B>[user] is [bragmessage]!</B>")

	if (!do_after(user, 10 SECONDS, src))
		user.Knockdown(2 SECONDS)
	else
		user.forceMove(last_loc)
		user.SpinAnimation(7,1)
		user.apply_status_effect(/datum/status_effect/exercised)
		for (var/mob/living/audience in view(7, src))
			audience.add_mood_event("performance", /datum/mood_event/dance_audience)

		if (emagged)
			user.visible_message("<B>[user] spins out of control!</B>")
			user.adjust_fire_stacks(2)
			user.ignite_mob()
			user.Knockdown(2 SECONDS)
		else
			user.emote("bow")

	user.plane = prev_plane
	user.pixel_y = prev_y
	STOP_PROCESSING(SSobj, src)
	dancer = null

/obj/structure/dancing_pole/process()
	var/mob/living/current_dancer = dancer?.resolve()
	if (!current_dancer)
		return
	if (!istype(current_dancer))
		return
	current_dancer.spin(2 SECONDS, 1)

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
