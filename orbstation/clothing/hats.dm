/// Ham Helmet, a helmet with the word ham on it
/obj/item/clothing/head/helmet/ham
	name = "ham helmet"
	desc = "Common Helmet with Ham written on it. Uh oh."
	icon = 'orbstation/icons/obj/helmet.dmi'
	worn_icon = 'orbstation/icons/obj/helmet.dmi'
	icon_state = "hamhelmeticon"
	worn_icon_state = "hamhelmetworn"
	armor = list(MELEE = 25, BULLET = 15, LASER = 35,ENERGY = 35, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)
	flags_cover = NONE
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/hamhelmet

/datum/dog_fashion/head/hamhelmet
	icon_file = 'orbstation/icons/obj/helmet.dmi'
	obj_icon_state = "hamhelmetian"
	name = "Ham Hunter REAL_NAME"
	desc = "NAME is wearing the Ham Helmet again..."
	emote_see = list("thinks about ham." )
