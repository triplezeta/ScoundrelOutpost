/// A different wand belt with randomised an less obviously useful options.
/obj/item/storage/belt/wands/discount
	/// Things which can appear
	var/static/list/possible_options = list(
		/obj/item/gun/magic/wand/resurrection,
		/obj/item/gun/magic/wand/teleport,
		/obj/item/gun/magic/wand/fireball,
		/obj/item/gun/magic/wand/door,
		/obj/item/gun/magic/wand/animate,
		/obj/item/gun/magic/wand/zap,
		/obj/item/gun/magic/wand/wound,
	)

/obj/item/storage/belt/wands/discount/PopulateContents()
	var/list/available_options = possible_options.Copy()
	for (var/i in 1 to 6)
		if (!length(available_options))
			break
		var/wand_path = pick_n_take(available_options)
		new wand_path(src)

	for (var/obj/item/gun/magic/wand/W in contents) //All wands in this pack come in the best possible condition
		W.max_charges = initial(W.max_charges)
		W.charges = W.max_charges

/**
 * Animate objects
 */
/obj/item/gun/magic/wand/animate
	name = "wand of animation"
	desc = "This wand is attuned to life and will animate effected objects into destructive servants."
	school = SCHOOL_EVOCATION
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/magic/staff_animation.ogg'
	max_charges = 10

/obj/item/gun/magic/wand/animate/zap_self(mob/living/user)
	. = ..()
	to_chat(user, span_warning("You animate one of your own possessions!"))
	charges--
	var/list/possessions = user.get_equipped_items()
	if (!length(possessions))
		to_chat(user, span_notice("...but you don't have any."))
		return

	var/obj/some_item = pick(possessions)
	user.dropItemToGround(some_item)
	some_item.animate_atom_living(user)

/**
 * Secretly just a taser
 */
/obj/item/gun/magic/wand/zap
	name = "wand of zapping"
	desc = "This wand overloads the nerves of your enemies with potent lightning."
	school = SCHOOL_EVOCATION
	ammo_type = /obj/item/ammo_casing/energy/electrode
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	fire_sound = 'sound/weapons/taser.ogg'
	max_charges = 8

/obj/item/gun/magic/wand/zap/zap_self(mob/living/user)
	. = ..()
	do_sparks(1, TRUE, src)
	user.add_mood_event("tased", /datum/mood_event/tased)
	user.apply_effects(paralyze = 10 SECONDS, stutter = 10 SECONDS, jitter = 40 SECONDS)
	SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
	charges--

/**
 * Medbay enrichment
 */
/obj/item/gun/magic/wand/wound
	name = "wand of wounding"
	desc = "The dark power of this wand manifests terrible wounds upon the living."
	school = SCHOOL_NECROMANCY
	ammo_type = /obj/item/ammo_casing/magic/wound
	icon_state = "deathwand"
	base_icon_state = "deathwand"
	fire_sound = 'sound/magic/wandodeath.ogg'
	max_charges = 5

/obj/item/gun/magic/wand/wound/zap_self(mob/living/user)
	. = ..()
	to_chat(user, span_boldwarning("You magically rend your own flesh!"))
	var/obj/item/bodypart/head/numbskull = user.get_bodypart(BODY_ZONE_HEAD)
	if (IS_ORGANIC_LIMB(numbskull))
		var/type_wound = pick(list(/datum/wound/blunt/critical, /datum/wound/slash/critical,
			/datum/wound/pierce/critical, /datum/wound/burn/critical,))
		numbskull.force_wound_upwards(type_wound)
	else
		numbskull.receive_damage(brute = 30)
	charges--

/obj/item/ammo_casing/magic/wound
	projectile_type = /obj/projectile/magic/wound

/obj/projectile/magic/wound
	name = "bolt of wounding"
	icon_state = "soulslash"
	damage = 15
	damage_type = BRUTE
	nodamage = FALSE
	/// Weighted list of inflicted wounds
	var/static/list/wound_effects = list(
		/datum/wound/blunt/critical = 1, /datum/wound/blunt/severe = 3,
		/datum/wound/slash/critical = 1, /datum/wound/slash/severe = 3,
		/datum/wound/pierce/critical = 1, /datum/wound/pierce/severe = 3,
		/datum/wound/burn/critical = 1, /datum/wound/burn/severe = 3,
	)

/obj/projectile/magic/wound/on_hit(atom/target)
	var/mob/living/carbon/victim = target
	if (!istype(victim))
		return
	var/obj/item/bodypart/wound_part = pick(victim.bodyparts)
	if (IS_ORGANIC_LIMB(wound_part))
		var/type_wound = pick_weight(wound_effects)
		wound_part.force_wound_upwards(type_wound)
	else
		wound_part.receive_damage(brute = 30)
