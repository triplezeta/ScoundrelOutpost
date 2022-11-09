// Brood mothers now get 6 eggs each, after that they only get more by eating people
/datum/action/innate/spider/lay_eggs
	/// How many eggs you get, these don't come back so use them wisely
	var/eggs_count = 6

/datum/action/innate/spider/lay_eggs/proc/update_desc()
	desc = initial(desc)
	desc += "<BR> You can lay [eggs_count] more of these eggs."

/datum/action/innate/spider/lay_eggs/IsAvailable(feedback = FALSE)
	. = ..()
	if (!.)
		return FALSE
	if (eggs_count <= 0)
		if (feedback)
			owner.balloon_alert(owner, "no eggs left!")
		return FALSE
	return TRUE

/datum/action/innate/spider/lay_eggs/lay_egg()
	. = ..()
	eggs_count--
	announce_remaining()
	UpdateButtons()

/datum/action/innate/spider/lay_eggs/proc/announce_remaining()
	owner.balloon_alert(owner, "[eggs_count] eggs remaining")

/datum/action/innate/spider/lay_eggs/UpdateButtons(status_only, force)
	. = ..()
	update_desc()

/datum/action/innate/spider/lay_eggs/enriched
	eggs_count = INFINITY // Has its own tracking and this makes keeping it modular easier

// Tracked with a different count
/datum/action/innate/spider/lay_eggs/enriched/update_desc()
	desc = initial(desc)
	desc += "<BR> You can lay [charges] more of these eggs."

// Tracked with a different count
/datum/action/innate/spider/lay_eggs/enriched/announce_remaining()
	owner.balloon_alert(owner, "[charges] eggs remaining")
