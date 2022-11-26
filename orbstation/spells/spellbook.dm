/**
 * Wizard spell entries.
 */

/datum/spellbook_entry/animate_limb
	name = "Animate Limb"
	desc = "Charges your hand with an unholy energy that can be used to cause a touched victim's limb to turn on them."
	spell_type = /datum/action/cooldown/spell/touch/animate_limb
	category = "Offensive"

/datum/spellbook_entry/tentacle_burst
	name = "Tentacle Burst"
	desc = "Conjure a wave of tentacles from the ground to grapple your foes."
	spell_type = /datum/action/cooldown/spell/aoe_staggered/tentacle_burst
	category = "Offensive"
