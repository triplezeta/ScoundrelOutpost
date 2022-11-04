/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "\improper Podperson"
	plural_form = "Podpeople"
	id = SPECIES_PODPERSON
	species_traits = list(MUTCOLORS, EYECOLOR, HAS_FLESH, HAS_BONE, POD_BLOOD)
	inherent_traits = list(
		TRAIT_PLANT_SAFE,
	)
	external_organs = list(
		/obj/item/organ/external/pod_hair = "None",
	)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_PLANT
	inherent_factions = list("plants", "vines")

	burnmod = 1.25
	heatmod = 1.5
	payday_modifier = 1.0
	meat = /obj/item/food/meat/slab/human/mutant/plant
	disliked_food = MEAT | DAIRY | SEAFOOD | BUGS
	liked_food = VEGETABLES | FRUIT | GRAIN
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/plant

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/pod,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/pod,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/pod,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/pod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/pod,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/pod,
	)

	ass_image = 'icons/ass/asspodperson.png'

/datum/species/pod/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	if(H.stat == DEAD)
		return

	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = min(1, T.get_lumcount()) - 0.5
		H.adjust_nutrition(5 * light_amount * delta_time)
		if(light_amount > 0.2) //if there's enough light, call the healing proc
			handle_light_healing(H, delta_time)

	if(H.nutrition > NUTRITION_LEVEL_ALMOST_FULL) //don't make podpeople fat because they stood in the sun for too long
		H.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(1 * delta_time, 0)
	..()

/datum/species/pod/proc/handle_light_healing(mob/living/carbon/human/H, delta_time)
	return //regular podpeople don't heal from light

/datum/species/pod/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, delta_time, times_fired)
	if(chem.type == /datum/reagent/toxin/plantbgone)
		H.adjustToxLoss(3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE

/datum/species/pod/randomize_features(mob/living/carbon/human_mob)
	randomize_external_organs(human_mob)

/datum/species/pod/get_species_description()
	return "A species of sentient plants, podpeople were created by a benevolent ancient society with the aim of 'spreading and nurturing life', their seed vaults \
		being tossed to all the far corners of the system. Being dispersed across the galaxy has caused their culture to fracture somewhat, and the exact \
		meaning of their creators intent is subject to frequent debate - not including those who simply don't care to listen."

/datum/species/pod/get_species_lore()
	return list(
		"Thousands of years ago, a precursor-society dispersed seed vaults throughout the galaxy. Within, the podpeople grew, and were given a single directive - \
		to protect the seed vaults they would grow into and nurture the life held within. ....However, the brevity of such a multi-faceted task would throw a \
		wrench into the inscrutable plans of the ancients.",

		"Even with the wide dispersal of the seed vaults, podpeople have formed a culture, most certainly drawing from the internal, subconscious memories of a \
		now long-dead society. They hold life in high regard, and see it their sacred duty to return life to inhospitable environs. These are considered the \
		more 'traditionalist' beliefs, alongside a somewhat-antiquated manner of speaking and dressing.",

		"Two other primary 'factions' exist within circles of podpeople, the 'reclusives' (mockingly referred to as 'wallflowers'); who believe that their \
		priorities should remain firmly within their seed vaults, keeping what vestiges of the ancient's society remain preserved in safety. They tend to be \
		slightly more up-to-date than their traditionalist counterparts, and a little grumpier when interacting with 'new' species. ",

		"The third and most disparate 'group' would be the 'sprouts', which encompasses those who find their original purpose stifling, and seek lives outside of \
		their seed vaults. Many podpeople would not declare themselves affiliated with any of these 'groups', but they define the forces shaping the course of \
		the podpeople's future.",

		"Most find a way out of their seed vaults when some haphazard miner wanders into their vault, but as time goes on, the idea of free communication and \
		sharing of techonlogy with other species spreads further. Many podpeople now leave their vaults in groups, once again dispersed amid the galaxy. Some \
		find fulfilling lives on the frontier, as farmers, shiphands and pirates. Some, even, end up working for NanoTrasen, loathe as they are to refuse \
		willing warm bodies.",
	)

/datum/species/pod/proc/change_hairstyle(mob/living/carbon/human/human_mob, new_style)
	var/obj/item/organ/external/organ = human_mob.getorganslot(ORGAN_SLOT_EXTERNAL_POD_HAIR)
	organ.set_sprite(new_style)
	human_mob.update_body_parts()

/datum/species/pod/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "lightbulb",
			SPECIES_PERK_NAME = "Light Nutrition",
			SPECIES_PERK_DESC = "Podpeople passively gain nutrition while standing in well-lit areas.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "tint",
			SPECIES_PERK_NAME = "Unique Blood",
			SPECIES_PERK_DESC = "Podpeople blood can be either water, or a random easily sourcable fruit juice",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "leaf",
			SPECIES_PERK_NAME = "Plant Weaknesses",
			SPECIES_PERK_DESC = "Podpeople are harmed by weedkiller, and mutate rapidly when shot with a floral somatoray on mutate mode. \
			Podpeople are also delicious to goats.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "lightbulb",
			SPECIES_PERK_NAME = "Light Starvation",
			SPECIES_PERK_DESC = "Podpeople lose nutrition while standing in darkness, and take constant damage while starving.",
		),
	)

	return to_add

//podperson sprouts - the same as regular podpeople in every way, except they also heal rapidly while standing in bright light.
//These only come from reviving someone via replica pod, or being spawned via the seed vault ghost role.
/datum/species/pod/sprout
	id = SPECIES_PODPERSON_SPROUT
	examine_limb_id = SPECIES_PODPERSON

//Sprouts heal rapidly while standing in light
/datum/species/pod/sprout/handle_light_healing(mob/living/carbon/human/H, delta_time)
	H.heal_overall_damage(0.5 * delta_time, 0.5 * delta_time, 0, BODYTYPE_ORGANIC)
	H.adjustToxLoss(-0.5 * delta_time)
	H.adjustOxyLoss(-0.5 * delta_time)
