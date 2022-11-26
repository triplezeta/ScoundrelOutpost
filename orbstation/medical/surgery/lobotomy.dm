/datum/surgery/advanced/lobotomy
	name = "Experimental Neural Bypass"

/datum/surgery_step/lobotomize
	name = "perform neural bypass"

/datum/surgery_step/lobotomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to rearrange the nerves in [target]'s brain..."),
		span_notice("[user] begins to perform an experimental bypass on [target]'s brain."),
		span_notice("[user] begins to perform surgery on [target]'s brain."))
	display_pain(target, "You can feel someone rooting around in your skull!")

/datum/surgery_step/lobotomize/success_output(mob/user, mob/living/carbon/target)
	display_results(user, target, span_notice("You succeed in reorganising [target]'s brain."),
		span_notice("[user] has reorganised [target]'s brain!"),
		span_notice("[user] completes the surgery on [target]'s brain."))
	display_pain(target, "Your head goes totally numb for a moment, the pain is overwhelming!")

/datum/surgery_step/lobotomize/fail_output(mob/user, mob/living/carbon/target)
	display_results(user, target, span_warning("You make a mistake, causing more damage!"),
		span_notice("[user] has reorganised [target]'s brain!"),
		span_notice("[user] completes the surgery on [target]'s brain."))
	display_pain(target, "The pain in your head only seems to get worse!")

/datum/design/surgery/lobotomy
	name = "Experimental Neural Bypass"
