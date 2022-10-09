/**
 * Versions of robeless abilities which I want to give to journeyman wizards.
 * They tend to be pretty powerful, so at the very least they should require robes.
 * This is especially true of teleporting spells, only Blink and Swap should reliably get you out of confinement.
 * I may need to come back to some of these and adjust their cooldowns or other properties further after we see them in play.
 *
 * These all gotta have different names for the spell assignment panel so I made them a bit more wizardy.
 *
 * Additionally wizard spells can have ranks and reduce their cooldown.
 * The only way journeymen can have access to this is via a random event, but it should affect these too.
 */

/datum/action/cooldown/spell/jaunt/bloodcrawl/wizard
	name = "Autotransfusion"
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC
	enter_blood_time = 2 SECONDS // Instant blood disappearing is a bit cheap

/datum/action/cooldown/spell/jaunt/shadow_walk/wizard
	name = "Shadowmeld"
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC
