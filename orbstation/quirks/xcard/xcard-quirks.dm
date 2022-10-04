//quirk subtype for x-card, prevents having to manually flag quirks as an x-card quirk
/datum/quirk/xcard
	xcard_quirk = TRUE
	abstract_parent_type = /datum/quirk/xcard
	icon = "x" //all x-card quirks use a big "X" icon for clarity
	value = 0 //x-card quirks are always free

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

/datum/quirk/xcard/rev_convert_immune
    name = "X-CARD: Revolution Conversion"
    desc = "Your powerful mental rigor prevents you from being forcefully recruited into revolutions. \
            Instead, conversion attempts will deal brain damage and brute damage to your head."
    mob_trait = TRAIT_XCARD_REV_IMMUNE

/datum/quirk/xcard/facehugger_immune
    name = "X-CARD: Facehuggers"
    desc = "Facehuggers are unable to infect you, and will instead bite your face, injecting a unique venom."
    mob_trait = TRAIT_XCARD_XENO_IMMUNE
/*
/datum/quirk/xcard/uncyborgable
    name = "Cyborg Incompatibility"
    desc = "Your brain is oddly-shaped, and will not fit into cyborg bodies or AI cores. \
            (It can still be put into an MMI, and you can still become a cyborg or AI if you enter a positronic brain as a ghost.)"
    mob_trait = TRAIT_XCARD_BORG_IMMUNE
*/

//proc to append x-card traits to examine text (everyone should be able to see these!)
/mob/living/carbon/human/proc/examine_xcards()
	var/list/xcard_list = list()
	var/list/msg = list()

	//bioscrambler immunity doesn't need to be noted here, as it's not relevant to other players
	if(HAS_TRAIT(src, TRAIT_XCARD_CULT_IMMUNE))
		xcard_list += span_notice("[p_they(TRUE)] [p_are()] immune to cult conversion, and will be gibbed if attempted.\n")
	if(HAS_TRAIT(src, TRAIT_XCARD_REV_IMMUNE))
		xcard_list += span_notice("[p_they(TRUE)] [p_are()] immune to revolutionary conversion, and will suffer brain damage instead.\n")
	if(HAS_TRAIT(src, TRAIT_XCARD_XENO_IMMUNE))
		xcard_list += span_notice("[p_they(TRUE)] [p_are()] immune to facehugger implantation, and will be injected with deadly neurotoxin instead.\n")
	if(HAS_TRAIT(src, TRAIT_XCARD_BORG_IMMUNE))
		xcard_list += span_notice("[p_their(TRUE)] brain cannot be used to make a cyborg or AI, though it can be placed into an MMI.\n")

	if(length(xcard_list))
		msg += span_notice("\n<b>[p_they(TRUE)] [p_have()] the following X-cards:</b>\n")
		msg += xcard_list

	return msg

