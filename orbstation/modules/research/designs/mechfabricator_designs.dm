//Mech Fabricator designs for Orbstation

#define RND_SUBCATEGORY_MECHFAB_CYBORG_CYBER_LIMBS "/Cybernetic Limbs"

/datum/design/digi_borg_l_leg
	name = "Digitigrade Cyborg Left Leg"
	id = "digi_borg_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/digitigrade
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CYBER_LIMBS
	)

/datum/design/digi_borg_r_leg
	name = "Digitigrade Cyborg Right Leg"
	id = "digi_borg_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/digitigrade
	materials = list(/datum/material/iron=10000)
	construction_time = 200
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_CYBER_LIMBS
	)
