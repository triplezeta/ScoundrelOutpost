/datum/species/zombie/infectious
	armor = 0 // let's not give zombies more armor for no reason
	brutemod = 1.25 // zombies are weak to brute-force attacks
	var/datum/action/zombie_bite/bite_action

/datum/species/zombie/infectious/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	if(ishuman(C))
		bite_action = new
		bite_action.Grant(C)
	if(HAIR in old_species.species_traits)
		species_traits |= HAIR
	if(FACEHAIR in old_species.species_traits)
		species_traits |= FACEHAIR
	return ..()

/datum/species/zombie/infectious/on_species_loss(mob/living/carbon/C)
	if(bite_action)
		bite_action.Remove(C)
	return ..()

/datum/species/zombie/infectious/spec_death(gibbed, mob/living/carbon/C)
	if(bite_action)
		bite_action.Remove(C)
	return ..()
