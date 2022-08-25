/// Time it takes to bite the target.
#define ZOMBIE_BITE_TIME 8 SECONDS

/datum/action/zombie_bite
	name = "Bite"
	icon_icon = 'icons/obj/medical/surgery.dmi'
	button_icon_state = "brain-x-d"
	/// Set to TRUE when the user is currently trying to bite someone.
	var/is_biting = FALSE

/datum/action/zombie_bite/Trigger(trigger_flags)
	var/mob/user = owner

	if(!can_bite(user))
		return

	var/mob/living/carbon/target = owner.pulling
	owner.visible_message(span_warning("[owner] begins biting through [target]'s skin!"), span_warning("You begin biting [target]!"))
	is_biting = TRUE

	if(!do_mob(owner, target, ZOMBIE_BITE_TIME))
		is_biting = FALSE
		return

	is_biting = FALSE
	bite_target(user, target)

/// Biting a target requires you to be conscious and have the target in a neck grab.
/datum/action/zombie_bite/proc/can_bite(mob/living/carbon/human/user)
	if(!user || !user.mind)
		return FALSE
	if(!ishuman(user))
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(is_biting)
		return FALSE
	if(!owner.pulling || !ishuman(owner.pulling))
		to_chat(owner, span_warning("You must be grabbing a person to use this action!"))
		return FALSE

	var/mob/living/carbon/human/target = owner.pulling
	CHECK_DNA_AND_SPECIES(target)
	if(ismonkey(target))
		to_chat(owner, span_warning("You can only bite humanoid targets!"))
		return FALSE
	if((NOBLOOD in target.dna.species.species_traits) || (NOZOMBIE in target.dna.species.species_traits)) // you cannot bite plasmamen, skeletons, golems, other zombies, etc
		to_chat(owner, span_warning("This person has no blood to infect!"))
		return FALSE
	if(owner.grab_state < GRAB_NECK)
		to_chat(owner, span_warning("You need a stronger grip to bite this person!"))
		return FALSE

	return TRUE

/// Attempts to infect the target, and creates a severe slash wound on the targeted bodypart.
/datum/action/zombie_bite/proc/bite_target(mob/living/user, mob/living/target, obj/item/bodypart/target_head)
	try_to_zombie_infect(target)

	owner.visible_message(span_danger("[owner] bites [target]!"), span_warning("You bite [target]!"))

	var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
	targeted_bodypart.force_wound_upwards(/datum/wound/slash/severe)

	log_combat(user, target, "zombie bit")

#undef ZOMBIE_BITE_TIME
