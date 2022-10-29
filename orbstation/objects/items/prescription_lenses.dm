/// Turns any eyewear into prescription glasses.
/obj/item/prescription_lenses
	name = "prescription lenses"
	icon = 'orbstation/icons/obj/accessibility.dmi'
	icon_state = "lenses"
	desc = "Use on any pair of glasses to attach corrective prescription lenses. \
		The added weight means they might fall off if you get into a scrape."
	w_class = WEIGHT_CLASS_TINY

/obj/item/prescription_lenses/afterattack(obj/item/clothing/glasses/target_glasses, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	if (!istype(target_glasses))
		return
	if (!isturf(target_glasses.loc))
		user.balloon_alert(user, "take glasses off") //They need to be outside your inventory or the trait won't apply
		return
	if (target_glasses.vision_correction)
		user.balloon_alert(user, "already corrective")
		return
	user.visible_message(span_notice("[user] starts attaching [src] to [target_glasses]."))
	if (!do_after(user, 5 SECONDS, target = target_glasses))
		user.balloon_alert(user, "interrupted")
		return
	target_glasses.vision_correction = TRUE
	user.balloon_alert(user, "success")
	target_glasses.AddComponent(/datum/component/knockoff, 25, list(BODY_ZONE_PRECISE_EYES), slot_flags)
	qdel(src)

/datum/crafting_recipe/prescription_lenses
	name = "Prescription Lens Kit"
	result = /obj/item/prescription_lenses
	time = 1.5 SECONDS
	reqs = list(/obj/item/clothing/glasses/regular = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_CLOTHING
