/datum/quirk/item_quirk/farsighted
	name = "Farsighted"
	desc = "You are farsighted - you won't be able to read a thing without prescription glasses. Fortunately, you spawn with a pair."
	icon = "magnifying-glass"
	value = -3
	gain_text = "<span class='danger'>Things close to you start looking blurry.</span>"
	lose_text = "<span class='notice'>You start seeing nearby things normally again.</span>"
	medical_record_text = "Patient requires prescription glasses in order to counteract farsightedness."
	mail_goodies = list(/obj/item/clothing/glasses/regular) // extra pair if orginal one gets broken by somebody mean
	var/glasses

/datum/quirk/item_quirk/farsighted/add_unique()
	glasses = glasses || quirk_holder.client?.prefs?.read_preference(/datum/preference/choiced/glasses)
	switch(glasses)
		if ("Thin")
			glasses = /obj/item/clothing/glasses/regular/thin
		if ("Circle")
			glasses = /obj/item/clothing/glasses/regular/circle
		if ("Hipster")
			glasses = /obj/item/clothing/glasses/regular/hipster
		else
			glasses = /obj/item/clothing/glasses/regular

	give_item_to_holder(glasses, list(LOCATION_EYES = ITEM_SLOT_EYES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/farsighted/add()
	quirk_holder.become_farsighted(QUIRK_TRAIT)

/datum/quirk/item_quirk/farsighted/remove()
	quirk_holder.cure_farsighted(QUIRK_TRAIT)

/mob/living/proc/cure_farsighted(source)
	REMOVE_TRAIT(src, TRAIT_FARSIGHT, source)
	if(!HAS_TRAIT(src, TRAIT_FARSIGHT))
		REMOVE_TRAIT(src, TRAIT_ILLITERATE, FARSIGHT_TRAIT)

/mob/living/proc/become_farsighted(source)
	if(!HAS_TRAIT(src, TRAIT_FARSIGHT))
		ADD_TRAIT(src, TRAIT_ILLITERATE, FARSIGHT_TRAIT)
	ADD_TRAIT(src, TRAIT_FARSIGHT, source)

/datum/mutation/human/farsighted
	name = "Far Sightedness"
	desc = "The holder of this mutation can't read without glasses."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>Things close to you start looking blurry.</span>"
	text_lose_indication = "<span class='notice'>You start seeing nearby things normally again.</span>"

/datum/mutation/human/farsighted/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.become_farsighted(GENETIC_MUTATION)

/datum/mutation/human/farsighted/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_farsighted(GENETIC_MUTATION)

/obj/item/dnainjector/farsighted
	name = "\improper DNA injector (Farsighted)"
	add_mutations = list(/datum/mutation/human/farsighted)

/obj/item/dnainjector/antifarsighted
	name = "\improper DNA injector (Anti-Farsighted)"
	remove_mutations = list(/datum/mutation/human/farsighted)
