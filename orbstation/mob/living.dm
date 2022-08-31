//Proc used to resuscitate a mob, for full_heal see fully_heal()
/mob/living/revive(full_heal = FALSE, admin_revive = FALSE, excess_healing = 0)
	var/was_dead = stat == DEAD
	. = ..()
	if (was_dead && stat != DEAD)
		to_chat(src, span_warning("You do not remember the moments leading up to your death!"))
