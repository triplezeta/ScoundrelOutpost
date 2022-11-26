/datum/quirk/throwingarm
	name = "Throwing Arm"
	desc = "Your arms have a lot of heft to them! Objects that you throw just always seem to fly further and faster than everyone elses, and you never miss a toss."
	icon = "baseball"
	value = 5
	mob_trait = TRAIT_THROWINGARM
	gain_text = "<span class='notice'>Your arms are full of energy!</span>"
	lose_text = "<span class='danger'>Your arms ache a bit.</span>"
	medical_record_text = "Patient displays mastery over throwing balls."
	mail_goodies = list(/obj/item/toy/beach_ball/baseball, /obj/item/toy/beach_ball/holoball, /obj/item/toy/beach_ball/holoball/dodgeball)


/obj/machinery/disposal/bin/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isitem(AM) && AM.CanEnterDisposals() && throwingdatum.thrower && HAS_TRAIT(throwingdatum.thrower, TRAIT_THROWINGARM))
		AM.forceMove(src)
		visible_message(span_notice("[AM] lands in [src]."))
		update_appearance()
	else
		return ..()

/obj/structure/holohoop/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if (isitem(AM) && !istype(AM,/obj/projectile) && throwingdatum.thrower && HAS_TRAIT(throwingdatum.thrower, TRAIT_THROWINGARM))
		AM.forceMove(get_turf(src))
		visible_message(span_warning("Swish! [AM] lands in [src]."))
		return
	else
		return ..()
