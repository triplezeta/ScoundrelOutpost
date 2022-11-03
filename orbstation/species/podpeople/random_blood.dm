/datum/species/pod/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	var/value = C.dna?.features?["pod_blood"]
	if(value == "Water")
		exotic_blood = /datum/reagent/water
	else if (value == "Juices")
		exotic_blood = pick(GLOB.pod_bloodtypes_juice)
	. = ..()
