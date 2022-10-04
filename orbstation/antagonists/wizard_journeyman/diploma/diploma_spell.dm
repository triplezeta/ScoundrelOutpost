/**
 * ## Diploma entries
 *
 * Wizard diplomas are automatically populated with
 * a list of every subtype when they're made.
 *
 * Functionally very similar to wizard spellbook entries
 * but with different spells and slightly different purchase functionality.
 */
/datum/diploma_spell
	/// The name of the entry
	var/name
	/// The description of the entry
	var/desc
	/// The type of spell that the entry grants (typepath)
	var/datum/action/cooldown/spell/spell_type
	/// What category the entry falls in
	var/category
	/// Flavor. Verb used in saying how the spell is aquired. Ex "[Learn] Fireball" or "[Summon] Ghosts"
	var/buy_word = "Learn"
	/// Whether the spell requires wizard garb or not
	var/requires_wizard_garb = FALSE
	/// How likely is this spell to be drafted?
	var/weight = DIPLOMA_SPELL_COMMON

/datum/diploma_spell/New()
	if(!ispath(spell_type))
		return
	if(initial(spell_type.spell_requirements) & SPELL_REQUIRES_WIZARD_GARB)
		requires_wizard_garb = TRUE

/**
 * Determines if this entry can be purchased from a spellbook
 * Used for configs / round related restrictions.
 *
 * Return FALSE to prevent the entry from being added to wizard spellbooks, TRUE otherwise
 */
/datum/diploma_spell/proc/can_be_purchased()
	if(!name || !desc || !category) // Erroneously set or abstract
		return FALSE
	return TRUE

/**
 * Actually buy the entry for the user
 *
 * Arguments
 * * user - the mob who's bought the spell
 *
 * Return TRUE if the purchase was successful, FALSE otherwise
 */
/datum/diploma_spell/proc/buy_spell(mob/living/carbon/human/user)
	var/datum/action/cooldown/spell/new_spell = new spell_type(user.mind || user)
	new_spell.Grant(user)
	to_chat(user, span_notice("You have learned [new_spell.name]."))

	log_spellbook("[key_name(user)] learned [new_spell]")
	SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, name)
	log_purchase(user.key)
	return TRUE

/datum/diploma_spell/proc/log_purchase(key)
	if(!islist(GLOB.wizard_spellbook_purchases_by_key[key]))
		GLOB.wizard_spellbook_purchases_by_key[key] = list()

	for(var/list/log as anything in GLOB.wizard_spellbook_purchases_by_key[key])
		if(log[LOG_SPELL_TYPE] == type)
			log[LOG_SPELL_AMOUNT]++
			return

	var/list/to_log = list(
		LOG_SPELL_TYPE = type,
		LOG_SPELL_AMOUNT = 1,
	)
	GLOB.wizard_spellbook_purchases_by_key[key] += list(to_log)

/// Item summons, they give you an item.
/datum/diploma_spell/item
	buy_word = "Summon"
	/// Typepath of what item we create when purchased
	var/obj/item/item_path

/datum/diploma_spell/item/buy_spell(mob/living/carbon/human/user)
	var/atom/spawned_path = new item_path(get_turf(user))
	log_spellbook("[key_name(user)] bought [src]")
	SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, name)
	try_equip_item(user, spawned_path)
	log_purchase(user.key)
	return spawned_path

/// Attempts to give the item to the buyer on purchase.
/datum/diploma_spell/item/proc/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_put_in_hands = user.put_in_hands(to_equip)
	to_chat(user, span_notice("\A [to_equip.name] has been summoned [was_put_in_hands ? "in your hands" : "at your feet"]."))
