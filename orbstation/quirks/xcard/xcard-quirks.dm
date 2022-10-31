//quirk subtype for x-card, prevents having to manually flag quirks as an x-card quirk
/datum/quirk/xcard
	xcard_quirk = TRUE
	abstract_parent_type = /datum/quirk/xcard
	icon = "x" //all x-card quirks use a big "X" icon for clarity
	value = 0 //x-card quirks are always free

	var/examine_text //text when quirk owner is examined, if any

/datum/quirk/xcard/bioscrambler_immune
	name = "X-CARD: Bioscrambler"
	desc = "Your physical form is abnormally stable, preventing your limbs from being replaced by bioscrambler \
			proximity. Instead, you will suffer from a random, highly detrimental effect when you would normally \
			be bioscrambled."
	mob_trait = TRAIT_BIOSCRAMBLER_IMMUNE //this is not ONLY an x-card trait, so it does not have "XCARD" in the name

/datum/quirk/xcard/cult_convert_immune
	name = "X-CARD: Cult Conversion"
	desc = "Your powerful mental rigor prevents you from being forcefully recruited into cults. \
			Instead, those awful cultists will sacrifice you in a shower of blood and viscera!"
	mob_trait = TRAIT_XCARD_CULT_IMMUNE
	examine_text = "immune to cult conversion, and will be gibbed if attempted."

/datum/quirk/xcard/rev_convert_immune
	name = "X-CARD: Revolution Conversion"
	desc = "Your powerful mental rigor prevents you from being forcefully recruited into revolutions. \
			Instead, conversion attempts will deal brain damage and brute damage to your head."
	mob_trait = TRAIT_XCARD_REV_IMMUNE
	examine_text = "immune to revolutionary conversion, and will suffer brain damage instead."

/datum/quirk/xcard/facehugger_immune
	name = "X-CARD: Facehuggers"
	desc = "Facehuggers are unable to infect you, and will instead bite your face, injecting a unique venom."
	mob_trait = TRAIT_XCARD_XENO_IMMUNE
	examine_text = "immune to facehugger implantation, and will be injected with deadly xenotoxin instead."

/datum/quirk/xcard/eye_trauma
	name = "X-CARD: Eye Trauma"
	desc = "Various sources of eye trauma will not be applied to you. Particularly, the traitor objective to steal someone's \
	 eyes will never select you as its target, eyesnatching devices will not work on you, and the objective will \
	 not be offered to you."
	mob_trait = TRAIT_XCARD_EYE_TRAUMA
	//no need for examine text - if someone tries using an eyesnatch device on someone that isn't their target I don't know what to tell them

/*
/datum/quirk/xcard/uncyborgable
	name = "Cyborg Incompatibility"
	desc = "Your brain is oddly-shaped, and will not fit into cyborg bodies or AI cores. \
			(It can still be put into an MMI, and you can still become a cyborg or AI if you enter a positronic brain as a ghost.)"
	mob_trait = TRAIT_XCARD_BORG_IMMUNE
	examine_text = span_notice("[p_their(TRUE)] brain cannot be used to make a cyborg or AI, though it can be placed into an MMI.\n")
*/

//proc to append x-card traits to examine text (everyone should be able to see these!)
/mob/living/carbon/human/proc/examine_xcards()
	var/list/xcard_list = list()
	var/list/msg = list()

	for (var/datum/quirk/xcard/quirk_type as anything in subtypesof(/datum/quirk/xcard))
		if(initial(quirk_type.examine_text) && HAS_TRAIT(src, initial(quirk_type.mob_trait)))
			xcard_list += span_notice("[p_they(TRUE)] [p_are()] [initial(quirk_type.examine_text)]\n")

	if(length(xcard_list))
		msg += span_notice("\n<b>[p_they(TRUE)] [p_have()] the following X-cards:</b>\n")
		msg += xcard_list

	return msg

//alternate mood event for the eyestab x-card
/datum/mood_event/face_stab
	description = "I just got stabbed in the face!"
	mood_change = -4
	timeout = 3 MINUTES
