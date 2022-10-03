/// Let's you draft wizard spells as a journeyman
/obj/item/wizard_diploma

	name = "wizarding certificate"
	desc = "An unearthly diploma confirming the achievements of a young wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	worn_icon_state = "scroll"
	inhand_icon_state = "paper"
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE

	/// The number of spells you can pick remaining
	var/picks = 3
	/// The mind that first used this. Automatically assigned when a wizard spawns.
	var/datum/mind/owner
	/// A list to all spellbook entries within
	var/list/entries = list()

/// Instantiates our list of spellbook entries.
/obj/item/wizard_diploma/proc/prepare_spells()
	var/entry_types = subtypesof(/datum/diploma_spell)
	for(var/type in entry_types)
		var/datum/diploma_spell/possible_entry = new type()
		if(!possible_entry.can_be_purchased())
			qdel(possible_entry)
			continue

		entries |= possible_entry

/obj/item/wizard_diploma/ui_data(mob/user)
	var/list/data = list()
	data["owner"] = owner
	data["picks"] = picks
	return data

/obj/item/wizard_diploma/ui_static_data(mob/user)
	var/list/data = list()
	var/list/entry_data = list()
	for(var/datum/diploma_spell/entry as anything in entries)
		var/list/individual_entry_data = list()
		individual_entry_data["name"] = entry.name
		individual_entry_data["desc"] = entry.desc
		individual_entry_data["ref"] = REF(entry)
		individual_entry_data["requires_wizard_garb"] = entry.requires_wizard_garb
		individual_entry_data["cat"] = entry.category
		individual_entry_data["buyword"] = entry.buy_word
		entry_data += list(individual_entry_data)

	data["entries"] = entry_data
	return data

/obj/item/wizard_diploma/examine(mob/user)
	. = ..()
	if(owner)
		. += {"A large signature confirms that this belongs to "[owner]"."}
	else
		. += "It doesn't appear to have been issued to anyone in particular."

/obj/item/wizard_diploma/attack_self(mob/user)
	if(!owner)
		if(!user.mind)
			return
		to_chat(user, span_notice("You eagerly sign [src]."))
		owner = user.mind
		return

	if(user.mind != owner)
		to_chat(user, span_warning("The words swim in front of your eyes."))
		return

	return ..()


/obj/item/wizard_diploma/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/wizard = usr
	if(!istype(wizard))
		to_chat(wizard, span_warning("You have no idea what to do with this."))
		return FALSE

	// Actions that are always available
	switch(action)
		if("purchase")
			var/datum/diploma_spell/entry = locate(params["spellref"]) in entries
			return purchase_entry(entry, wizard)

/// Attempts to purchased the passed entry [to_buy] for [user].
/obj/item/wizard_diploma/proc/purchase_entry(datum/diploma_spell/to_buy, mob/living/carbon/human/user)
	if (picks <= 0)
		return FALSE
	if(!istype(to_buy))
		CRASH("Spellbook attempted to buy an invalid entry. Got: [to_buy ? "[to_buy] ([to_buy.type])" : "null"]")
	if(!to_buy.buy_spell(user, src))
		return FALSE

	picks--
	return TRUE
