/datum/religion_sect/rat
	name = "Rat Worship"
	desc = "Sacrifice cheese and mouse traps to grant favour."
	quote = "Let's see what kind of trouble we can get ourselves into."
	tgui_icon = "cheese-swiss"
	alignment = ALIGNMENT_NEUT
	desired_items = list(/obj/item/food/ = "(especially cheese and dairy)", /obj/item/assembly/mousetrap)
	altar_icon_state = "convertaltar-maint"

/datum/religion_sect/rat/sect_bless(mob/living/target, mob/living/chap)
	to_chat(chap, span_boldnotice("Debug [target.real_name] [israt(target)] [ismouse(target)] [target.faction] [chap.faction] [target.health] [target.maxHealth]"))
	if(ishuman(target))
		return FALSE

	var/heal_amt = 15
	if (israt(target))
		var/mob/living/simple_animal/hostile/rat/blessedR = target
		if(faction_check(blessedR.faction, chap.faction, FALSE))
			blessedR.faction |= chap.faction
			blessedR.visible_message(span_notice("[blessedR] looks upon [chap] with greater kinship through the power of [GLOB.deity]!"))
			to_chat(blessedR, span_boldnotice("May the power of [GLOB.deity] compel you to be healed!"))
		if(blessedR.health < blessedR.maxHealth)
			blessedR.heal_ordered_damage(heal_amt)
			blessedR.visible_message(span_notice("[chap] heals [blessedR] with the power of [GLOB.deity]!"))
			to_chat(blessedR, span_boldnotice("May the power of [GLOB.deity] compel you to be healed!"))
			playsound(chap, SFX_PUNCH, 25, TRUE, -1)
			SEND_SIGNAL(blessedR, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)

	else if(ismouse(target))
		if(target.health < target.maxHealth)
			var/mob/living/simple_animal/mouse/blessedM = target
			target.heal_ordered_damage(heal_amt)
			blessedM.visible_message(span_notice("[chap] heals [blessedM] with the power of [GLOB.deity]!"))
			to_chat(blessedM, span_boldnotice("May the power of [GLOB.deity] compel you to be healed!"))
			playsound(chap, SFX_PUNCH, 25, TRUE, -1)
			SEND_SIGNAL(blessedM, COMSIG_ADD_MOOD_EVENT, "blessing", /datum/mood_event/blessing)
	return TRUE

/datum/religion_sect/rat/on_sacrifice(obj/item/I, mob/living/chap)
	if(istype(I, /obj/item/assembly/mousetrap))
		var/trap_favour = 20
		to_chat(chap, span_notice("[GLOB.deity] is pleased that this trap will trouble their children no more."))
		adjust_favor(trap_favour, chap)
		qdel(I)
		return TRUE

	if (IS_EDIBLE(I))
		var/obj/item/food/the_food = I
		var/datum/reagent/N = I.reagents.has_reagent(/datum/reagent/consumable/nutriment)
		var/food_favour = N.volume + 1
		if (the_food.foodtypes & DAIRY)
			food_favour *= 2

		adjust_favor(food_favour, chap)
		to_chat(chap, span_notice("You offer [the_food] to [GLOB.deity], pleasing them."))
		qdel(I)
		return TRUE

	return
