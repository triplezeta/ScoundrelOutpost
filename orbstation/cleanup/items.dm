/obj/item/slimepotion/genderchange
	desc = "An interesting chemical mix that changes the gender of what it's applied to. Can only be used on yourself."

/obj/item/slimepotion/genderchange/attack(mob/living/L, mob/user)
	if(L != user)
		to_chat(user, span_warning("You can't use this on someone else!"))
		return

	..()

/obj/item/storage/book/bible
	name = "holy book"
	icon_state = "holybook"
	inhand_icon_state = "holybook"
	worn_icon_state = "holybook"

/obj/item/food/raw_meatball
	desc = "A great meal all round. Kinda raw"

/obj/item/food/meatball
	desc = "A great meal all round."
