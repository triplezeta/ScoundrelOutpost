/obj/item/ammo_casing/magic/teleport
	projectile_type = /obj/projectile/magic/teleport

/// Essentially a self-charging version of the teleport wand
/obj/item/gun/magic/staff/teleport
	name = "staff of teleportation"
	desc = "An artefact that teleports objects hit by it to other places! There's no guarantee these will be safe places."
	fire_sound = 'sound/magic/staff_animation.ogg'
	ammo_type = /obj/item/ammo_casing/magic/teleport
	icon_state = "staffofchaos"
	inhand_icon_state = "staffofchaos"
	school = SCHOOL_TRANSLOCATION
