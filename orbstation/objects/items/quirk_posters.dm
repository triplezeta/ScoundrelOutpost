/obj/item/poster/quirk
	name = "placeholder quirk poster"
	desc = "Uh oh! You shouldn't have this!"
	icon = 'icons/obj/contraband.dmi'
	icon_state = "rolled_legit"
	var/quirk_poster_department = NONE

/obj/item/poster/quirk/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	if(poster_structure)
		var/obj/structure/sign/poster/quirk/department_grab = poster_structure
		department_grab.quirk_poster_department = quirk_poster_department

/// You can use any spraypaint can on a quirk poster to turn it into a contraband poster from the traitor objective
/obj/item/poster/quirk/attackby(obj/item/postertool, mob/user, params)
	if(!is_special_character(user))
		return ..()
	if(!istype(postertool, /obj/item/toy/crayon))
		return ..()
	balloon_alert(user, "converting poster...")
	if(!do_after(user, 5 SECONDS, src))
		balloon_alert(user, "interrupted!")
		return
	var/obj/item/poster/traitor/quirkspawn = new(get_turf(src))
	moveToNullspace()
	user.put_in_hands(quirkspawn)
	to_chat(user, span_notice("You have converted one of your posters!"))
	qdel(src)

/obj/structure/sign/poster/quirk
	name = "quirk poster"
	desc = "A large piece of homemade space-resistant printed paper."
	icon = 'orbstation/icons/obj/quirk_posters.dmi'
	var/quirk_poster_department = NONE


/// All new poster items are below, starting with the two random posters types
/obj/item/poster/quirk/random
	poster_type = /obj/structure/sign/poster/quirk/random

/obj/structure/sign/poster/quirk/random
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/quirk

/obj/item/poster/quirk/crew/random
	poster_type = /obj/structure/sign/poster/quirk/crew/random

/obj/structure/sign/poster/quirk/crew/random
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/quirk/crew

/obj/structure/sign/poster/quirk/crew/one
	name = "Crew Poster 1"
	desc = "Desc 1"
	icon_state = "crew_1"

/obj/structure/sign/poster/quirk/crew/two
	name = "Crew Poster 2"
	desc = "Desc 2"
	icon_state = "crew_2"

/obj/structure/sign/poster/quirk/crew/three
	name = "Crew Poster 3"
	desc = "Desc 3"
	icon_state = "crew_3"

/obj/item/poster/quirk/cargo/one
	poster_type = /obj/structure/sign/poster/quirk/cargo/one
	quirk_poster_department = ACCOUNT_CAR

/obj/structure/sign/poster/quirk/cargo/one
	name = "Car Poster 1"
	desc = "Desc 1"
	icon_state = "car_1"

/obj/item/poster/quirk/cargo/two
	poster_type = /obj/structure/sign/poster/quirk/cargo/two
	quirk_poster_department = ACCOUNT_CAR

/obj/structure/sign/poster/quirk/cargo/two
	name = "Car Poster 2"
	desc = "Desc 2"
	icon_state = "car_2"

/obj/item/poster/quirk/engineering/one
	poster_type = /obj/structure/sign/poster/quirk/engineering/one
	quirk_poster_department = ACCOUNT_ENG

/obj/structure/sign/poster/quirk/engineering/one
	name = "Eng Poster 1"
	desc = "Desc 1"
	icon_state = "eng_1"

/obj/item/poster/quirk/engineering/twp
	poster_type = /obj/structure/sign/poster/quirk/engineering/two
	quirk_poster_department = ACCOUNT_ENG

/obj/structure/sign/poster/quirk/engineering/two
	name = "Eng Poster 2"
	desc = "Desc 2"
	icon_state = "eng_2"

/obj/item/poster/quirk/medical/one
	poster_type = /obj/structure/sign/poster/quirk/medical/one
	quirk_poster_department = ACCOUNT_MED

/obj/structure/sign/poster/quirk/medical/one
	name = "Med Poster 1"
	desc = "Desc 1"
	icon_state = "med_1"

/obj/item/poster/quirk/medical/two
	poster_type = /obj/structure/sign/poster/quirk/medical/two
	quirk_poster_department = ACCOUNT_MED

/obj/structure/sign/poster/quirk/medical/two
	name = "Med Poster 2"
	desc = "Desc 2"
	icon_state = "med_2"

/obj/item/poster/quirk/science/one
	poster_type = /obj/structure/sign/poster/quirk/science/one
	quirk_poster_department = ACCOUNT_SCI

/obj/structure/sign/poster/quirk/science/one
	name = "Sci Poster 1"
	desc = "Desc 1"
	icon_state = "sci_1"

/obj/item/poster/quirk/science/two
	poster_type = /obj/structure/sign/poster/quirk/science/two
	quirk_poster_department = ACCOUNT_SCI

/obj/structure/sign/poster/quirk/science/two
	name = "Sci Poster 2"
	desc = "Desc 2"
	icon_state = "sci_2"

/obj/item/poster/quirk/security/one
	poster_type = /obj/structure/sign/poster/quirk/security/one
	quirk_poster_department = ACCOUNT_SEC

/obj/structure/sign/poster/quirk/security/one
	name = "Sec Poster 1"
	desc = "Desc 1"
	icon_state = "sec_1"

/obj/item/poster/quirk/secuirty/two
	poster_type = /obj/structure/sign/poster/quirk/security/two
	quirk_poster_department = ACCOUNT_SEC

/obj/structure/sign/poster/quirk/security/two
	name = "Sec Poster 2"
	desc = "Desc 2"
	icon_state = "sec_2"

/obj/item/poster/quirk/service/one
	poster_type = /obj/structure/sign/poster/quirk/service/one
	quirk_poster_department = ACCOUNT_SRV

/obj/structure/sign/poster/quirk/service/one
	name = "Srv Poster 1"
	desc = "Desc 1"
	icon_state = "srv_1"

/obj/item/poster/quirk/service/two
	poster_type = /obj/structure/sign/poster/quirk/service/two
	quirk_poster_department = ACCOUNT_SRV

/obj/structure/sign/poster/quirk/service/two
	name = "Srv Poster 2"
	desc = "Desc 2"
	icon_state = "srv_2"
