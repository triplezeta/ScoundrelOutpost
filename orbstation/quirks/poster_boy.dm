/datum/quirk/item_quirk/poster_boy
	name = "Poster Boy"
	desc = "You have some great posters! Hang them up and make everyone have a great time."
	icon = "tape"
	value = 4
	mob_trait = TRAIT_POSTERBOY
	medical_record_text = "Patient reports a desire to cover walls with homemade objects."
	mail_goodies = list(/obj/item/poster/random_official)

/datum/quirk/item_quirk/poster_boy/add_unique()
	var/mob/living/carbon/human/posterboy = quirk_holder
	var/obj/item/storage/box/posterbox/newbox = new()
	newbox.add_quirk_posters(posterboy.mind)
	give_item_to_holder(newbox, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/obj/item/storage/box/posterbox
	name = "Box of Posters"
	desc = "You made them yourself!"

/obj/item/storage/box/posterbox/proc/add_quirk_posters(datum/mind/posterboy)
	new /obj/item/poster/quirk/crew/random(src)
	var/department = posterboy.assigned_role.paycheck_department
	if(department == ACCOUNT_CIV)
		for(var/i in 1 to 2)
			new /obj/item/poster/quirk/random(src)
		return
	for(var/potential_poster in subtypesof(/obj/item/poster/quirk))
		var/obj/item/poster/quirk/new_dept_poster = new potential_poster()
		if(new_dept_poster.quirk_poster_department != department)
			qdel(new_dept_poster)
			continue
		new_dept_poster.forceMove(src)
