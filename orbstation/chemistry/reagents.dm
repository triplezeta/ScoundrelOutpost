// POTASSIUM SALT

/datum/reagent/potassium_salt
	name = "Potassium Salt"
	description = "A form of potassium that is commonly found in bananas. A little bit of heat can turn it into regular potassium."
	reagent_state = SOLID
	color = "#E0E0E0" // rgb: 224, 224, 224
	taste_description = "antics"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// CHEESE REAGENT

/datum/reagent/consumable/cheese
	name = "Cheese Sauce"
	description = "Rats can't get enough of the stuff!"
	color = "#FFC814" // rgb: 225, 200, 20
	taste_description = "cheese"
	glass_icon_state = "glass_yellow"
	glass_name = "glass of cheese sauce"
	glass_desc = "Rats can't get enough of the stuff!"
	ph = 6.7 // the same as milk
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/obj/item/food/cheese
	/// Amount of cheese reagent that will be added to a person after eating the food.
	var/cheesiness = 3

/obj/item/food/cheese/MakeEdible()
	..()
	if(cheesiness)
		var/datum/component/edible/e = GetComponent(/datum/component/edible)
		if(e)
			if(!e.after_eat) // we want to allow this to be overridden if necessary
				e.after_eat = CALLBACK(src, PROC_REF(add_cheese))

///Adds the cheese reagent to cheese based on its cheesiness value.
/obj/item/food/cheese/proc/add_cheese(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/h = eater
		h.reagents.add_reagent(/datum/reagent/consumable/cheese, cheesiness)

/obj/item/food/cheese/wheel
	cheesiness = 5

/obj/item/food/cheese/royal
	cheesiness = 10

/obj/item/food/cheese/curd_cheese
	cheesiness = 2

/obj/item/food/cheese/firm_cheese_slice
	cheesiness = 2
