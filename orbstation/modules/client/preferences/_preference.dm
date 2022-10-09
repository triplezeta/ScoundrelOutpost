//Additional preference types for Orbstation

/// A preference for text and text input. Obtained from Skyrat.
/datum/preference/text
	abstract_type = /datum/preference/text

/datum/preference/text/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_SIMPLE(input, MAX_FLAVOR_LEN)

/datum/preference/text/create_default_value()
	return ""

/datum/preference/text/is_valid(value)
	return istext(value)

/// A preference for shorter text input (no more than 200 characters).
/datum/preference/text/short
	abstract_type = /datum/preference/text/short

/datum/preference/text/short/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_SIMPLE(input, MAX_SHORT_FLAVOR_LEN)
