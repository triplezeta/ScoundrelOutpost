/**
 * I am cheating a bit by giving some (mostly heretic) spells to wizard journeyman.
 * These were made robeless because they're not given to wizards.
 * They tend to be pretty powerful, so at the very least they should require robes.
 * This is especially true of teleporting spells, only Blink and Swap should reliably get you out of confinement.
 * I may need to come back to some of these and adjust their cooldowns or other properties further after we see them in play.
 */

/datum/action/cooldown/spell/jaunt/mirror_walk/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/jaunt/bloodcrawl/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC
	enter_blood_time = 2 SECONDS // Instant blood disappearing is a bit cheap

/datum/action/cooldown/spell/jaunt/shadow_walk/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/pointed/projectile/furious_steel/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/cone/staggered/entropic_plume/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/pointed/void_phase/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/aoe/void_pull/wizard
	spell_requirements = SPELL_REQUIRES_WIZARD_GARB|SPELL_REQUIRES_NO_ANTIMAGIC
