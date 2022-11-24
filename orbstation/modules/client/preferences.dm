/datum/preferences
	/// Associative list, keyed by language typepath, pointing to LANGUAGE_UNDERSTOOD, or LANGUAGE_SPOKEN, for whether we understand or speak the language
	var/list/languages = list()

/// This helper proc gets the current species language holder and does any post-processing that's required in one easy to track place.
/// This proc should *always* be edited or used when modifying or getting the default languages of a player controlled, unrestricted species, to prevent any errant conflicts.
/datum/preferences/proc/get_adjusted_language_holder()
	var/datum/species/species = read_preference(/datum/preference/choiced/species)
	species = new species()
	var/datum/language_holder/language_holder = new species.species_language_holder()

	return language_holder

// Whenever we switch a species, we'll try to get common if we can to not confuse anyone
/datum/preferences/proc/try_get_common_language()
	var/datum/language_holder/language_holder = get_adjusted_language_holder()
	var/language = language_holder.spoken_languages[1]
	return language
