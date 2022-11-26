//Overrides to prevent non-crew antags from yoinking your character's flavor text. They aren't supposed to be your character!
/datum/antagonist/wizard/equip_wizard()
	..()
	var/mob/living/carbon/human/H = owner.current
	H.dna.features["flavor_text"] = null
	H.dna.features["flavor_text_short"] = null

/datum/antagonist/wizard_journeyman/equip_wizard()
	..()
	var/mob/living/carbon/human/H = owner.current
	H.dna.features["flavor_text"] = null
	H.dna.features["flavor_text_short"] = null

/datum/antagonist/abductor/finalize_abductor()
	..()
	var/mob/living/carbon/human/H = owner.current
	H.dna.features["flavor_text"] = null
	H.dna.features["flavor_text_short"] = null

/datum/antagonist/ert/equipERT()
	..()
	var/mob/living/carbon/human/H = owner.current
	H.dna.features["flavor_text"] = null
	H.dna.features["flavor_text_short"] = null
