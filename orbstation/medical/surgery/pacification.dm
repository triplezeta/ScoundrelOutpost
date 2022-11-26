/datum/surgery/advanced/pacify
	desc = "A surgical procedure which implants a chip into the brain, making the patient unwilling to cause direct harm. \
		This chip can only be terminated by CentCom officials following an official investigation."

/datum/surgery_step/pacify
	name = "attach chip"

/datum/surgery_step/pacify/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to carefully insert the chip into [target]..."),
		span_notice("[user] begins to fix [target]'s brain."),
		span_notice("[user] begins to perform surgery on [target]'s brain."))
	display_pain(target, "You can feel someone rooting around in your skull!")

/datum/surgery_step/pacify/success_output(mob/user, mob/living/carbon/target)
	display_results(user, target, span_notice("You succeed in artifically pacifying [target]."),
		span_notice("[user] successfully fixes [target]'s brain!"),
		span_notice("[user] completes the surgery on [target]'s brain."))
	display_pain(target, "Your head pounds... the concept of violence flashes in your head, and nearly makes you hurl!")
