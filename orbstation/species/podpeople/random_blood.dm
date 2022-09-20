
/datum/species/pod/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	exotic_blood = pick(GLOB.pod_bloodtypes)
	. = ..()


