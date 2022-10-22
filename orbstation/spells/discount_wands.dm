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
		/obj/item/gun/magic/wand/freeze,
		/obj/item/gun/magic/wand/prank,
		/obj/item/gun/magic/wand/hallucination,
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
 * Medbay enrichment, directly applies wounds or just damage to wound-proof limbs
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

/**
 * Prank wand knocks you over as if pied and surrounds you with space lube
 */
/obj/item/gun/magic/wand/prank
	name = "wand of pratfalls"
	desc = "A comedy wand which is sure to get a laugh out of you, if not its victims."
	school = SCHOOL_CONJURATION
	ammo_type = /obj/item/ammo_casing/magic/prank
	icon_state = "nothingwand"
	base_icon_state = "nothingwand"
	fire_sound = 'sound/items/bikehorn.ogg'
	max_charges = 10

/obj/item/gun/magic/wand/prank/zap_self(mob/living/user)
	. = ..()
	var/obj/item/food/pie/cream/pie/magical/pie = new(src)
	pie.splat(user)
	charges--

/obj/item/ammo_casing/magic/prank
	projectile_type = /obj/projectile/magic/prank

/obj/projectile/magic/prank
	name = "bolt of pratfalls"
	icon_state = "ice_2"
	/// Our internal pie
	var/obj/item/food/pie/cream/pie/magical/pie = new()

/obj/projectile/magic/prank/on_hit(atom/target)
	. = ..()
	pie.splat(target)

/// This creates an extremely messy cream pie which your audience will love
/obj/item/food/pie/cream/pie/magical

/obj/item/food/pie/cream/pie/magical/splat(atom/movable/hit_atom)
	var/datum/reagents/lube = new /datum/reagents(1000)
	lube.add_reagent(/datum/reagent/lube, 100)
	lube.my_atom = get_turf(hit_atom)
	lube.create_foam(/datum/effect_system/fluid_spread/foam, DIAMOND_AREA(2))
	qdel(lube)
	var/laugh_sound = list('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg')
	playsound(hit_atom, laugh_sound, 100, FALSE)
	return ..()

/**
 * Freezing wand places you in an ice cube and creates ice turfs
 */
/obj/item/gun/magic/wand/freeze
	name = "wand of ice"
	desc = "The chilling power of this wand will stop your enemies in their tracks."
	school = SCHOOL_EVOCATION
	ammo_type = /obj/item/ammo_casing/magic/freeze
	icon_state = "telewand"
	base_icon_state = "telewand"
	fire_sound = 'sound/magic/blink.ogg'
	max_charges = 8

/obj/item/gun/magic/wand/freeze/zap_self(mob/living/user)
	. = ..()
	to_chat(user, span_warning("You freeze yourself in a block of ice!"))
	user.apply_status_effect(/datum/status_effect/ice_block_talisman, 10 SECONDS)
	var/turf/hit_turf = get_turf(user)
	if (isfloorturf(hit_turf) && !isspaceturf(hit_turf) && !isindestructiblefloor(hit_turf))
		hit_turf.ChangeTurf(/turf/open/floor/fakeice/slippery, flags = CHANGETURF_INHERIT_AIR)
	charges--

/obj/item/ammo_casing/magic/freeze
	projectile_type = /obj/projectile/magic/freeze

/obj/projectile/magic/freeze
	name = "bolt of freezing"
	icon_state = "ice_2"

/obj/projectile/magic/freeze/on_hit(atom/target)
	var/turf/hit_turf = get_turf(target)
	if (isfloorturf(hit_turf) && !isspaceturf(hit_turf) && !isindestructiblefloor(hit_turf))
		hit_turf.ChangeTurf(/turf/open/floor/fakeice/slippery, flags = CHANGETURF_INHERIT_AIR)

	var/mob/living/victim = target
	if (!istype(victim))
		return
	victim.apply_status_effect(/datum/status_effect/ice_block_talisman, 10 SECONDS)

/**
 * Hallucination wand looks exactly like a bolt of chaos except whatever happens isn't real
 * One of the few times people might actually fall for hallucinations of being set on fire or turned into a xenomorph
 * Even if they don't, several of these are minor stuns anyway
 */
/obj/item/gun/magic/wand/hallucination
	name = "wand of chaos"
	desc = "A wand which spits bolts of hallucinogenic magic which can do almost anything, or at least make the victim think so."
	school = SCHOOL_FORBIDDEN
	ammo_type = /obj/item/ammo_casing/magic/hallucination
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/magic/staff_chaos.ogg'
	max_charges = 20

#define FUNNY_WIZARD_HALLUCINATIONS list(\
	/datum/hallucination/death,\
	/datum/hallucination/fire,\
	/datum/hallucination/oh_yeah,\
	/datum/hallucination/xeno_attack,\
	/datum/hallucination/hazard/lava,\
	/datum/hallucination/hazard/chasm,\
	/datum/hallucination/hazard/anomaly,\
	/datum/hallucination/ice,\
	/datum/hallucination/shock,\
	/datum/hallucination/delusion/preset/monkey,\
	/datum/hallucination/delusion/preset/corgi,\
	/datum/hallucination/delusion/preset/carp,\
	/datum/hallucination/delusion/preset/skeleton,\
	/datum/hallucination/delusion/preset/zombie,\
	/datum/hallucination/delusion/preset/cyborg,\
	/datum/hallucination/delusion/preset/ghost,\
	/datum/hallucination/delusion/preset/syndies,)

/obj/item/gun/magic/wand/hallucination/zap_self(mob/living/user)
	. = ..()
	var/datum/hallucination/picked_hallucination = pick(FUNNY_WIZARD_HALLUCINATIONS)
	user.cause_hallucination(picked_hallucination, "wand")
	charges--

/obj/item/ammo_casing/magic/hallucination
	projectile_type = /obj/projectile/magic/hallucination

/obj/projectile/magic/hallucination
	// Eagle eyed players may be aware that there's no such thing as a real bolt of chaos projectile
	name = "bolt of chaos"
	icon_state = "ice_1"

/obj/projectile/magic/hallucination/on_hit(atom/target)
	. = ..()
	var/mob/living/carbon/victim = target
	if (!istype(victim))
		return
	var/datum/hallucination/picked_hallucination = pick(FUNNY_WIZARD_HALLUCINATIONS)
	victim.cause_hallucination(picked_hallucination, "wand")

#undef FUNNY_WIZARD_HALLUCINATIONS

/**
 * Wand which makes you drunk, self-explanatory
 */

/obj/item/gun/magic/wand/booze
	name = "party wand"
	desc = "A wand which fills its target with copious amounts of alcohol. Use in moderation, unless you are \
		trying to give someone liver damage."
	school = SCHOOL_CONJURATION
	ammo_type = /obj/item/ammo_casing/magic/booze
	icon_state = "nothingwand"
	base_icon_state = "nothingwand"
	fire_sound = 'sound/effects/slosh.ogg'
	max_charges = 10

/obj/item/gun/magic/wand/booze/zap_self(mob/living/user)
	. = ..()
	user.visible_message(span_notice("[user] puts the [src] up to [user.p_their()] mouth and starts chugging!"))
	var/datum/reagent/consumable/ethanol/bacchus_blessing/booze = new()
	booze.expose_mob(user, INGEST)
	user.reagents.add_reagent(booze.type, 5)
	charges--

/obj/item/ammo_casing/magic/booze
	projectile_type = /obj/projectile/magic/booze

/obj/projectile/magic/booze
	name = "bolt of inebriation"
	icon_state = "energy"

/obj/projectile/magic/booze/on_hit(atom/target)
	. = ..()
	var/mob/living/carbon/victim = target
	if (!istype(victim))
		return
	var/datum/reagent/consumable/ethanol/bacchus_blessing/booze = new() // Only the best for wizards. Two shots is 60% liver damage.
	booze.expose_mob(victim, INGEST)
	victim.reagents.add_reagent(booze.type, 5)

/**
 * Pax wand is a minor heal which applies temporary pacifism, gives you time to talk it out?
 */


/**
 * Repulsor wand throws things backwards, might hurt them a lot if they ram something
 */

/**
 * Levitation wand applies anti-gravity to target. Moths love it.
 */

/**
 * Light wand creates permanent light sources.
 */

/**
 * Portal wand, makes one portal somewhere and one at your feet.
 */

/**
 * Swap wand, swap places with another atom
 */

/**
 * Wand of connection, makes runes which teleport you to random other runes when crossed
 */

/**
 * Wand of pizza, turns turfs and objects into pizza but you gotta eat them yourself
 */

/**
 * Barnyard wand, summons small animal rifts, not really necessarily very useful for anything in particular
 */

/**
 * Temporary babel effect, makes you forget all other languages except a random new one
 */
