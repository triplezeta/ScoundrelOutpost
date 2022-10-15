// SNOUT

/obj/item/organ/external/snout_rat
	name = "ratfolk snout"
	desc = "Take a closer look at that snout!"
	icon_state = "snout"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SNOUT
	layers = EXTERNAL_ADJACENT

	feature_key = "rat_snout"
	preference = "feature_rat_snout"
	external_bodytypes = BODYTYPE_SNOUTED

	color_source = ORGAN_COLOR_OVERRIDE

	dna_block = DNA_RAT_SNOUT_BLOCK

/obj/item/organ/external/snout_rat/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_mask?.flags_inv & HIDESNOUT) && !(human.head?.flags_inv & HIDESNOUT))
		return TRUE
	return FALSE

/obj/item/organ/external/snout_rat/get_global_feature_list()
	return GLOB.rat_snouts_list

/obj/item/organ/external/snout_rat/override_color(rgb_value)
	if(sprite_datum && sprite_datum.color_src == FACEHAIR && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		return H.facial_hair_color

	return rgb_value

// TAIL

/obj/item/organ/external/tail/ratfolk
	name = "ratfolk tail"
	desc = "A severed rat tail."
	feature_key = "rat_tail"
	preference = "feature_rat_tail"
	dna_block = DNA_RAT_TAIL_BLOCK

/obj/item/organ/external/tail/ratfolk/get_global_feature_list()
	return GLOB.rat_tails_list
