/datum/preference/text/flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text"

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["flavor_text"] = value

/datum/preference/text/silicon_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "silicon_flavor_text"
	// This does not get a apply_to_human proc, this is read directly in silicon/robot/examine.dm

/datum/preference/text/silicon_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE // To prevent the not-implemented runtime

/datum/preference/text/short/flavor_text_short
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "flavor_text_short"

/datum/preference/text/short/flavor_text_short/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["flavor_text_short"] = value

/datum/preference/text/short/silicon_flavor_text_short
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "silicon_flavor_text_short"
	// This does not get a apply_to_human proc, this is read directly in silicon/robot/examine.dm

/datum/preference/text/short/silicon_flavor_text_short/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE // To prevent the not-implemented runtime
