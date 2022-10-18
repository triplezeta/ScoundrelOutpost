/**
 * Rune events which trigger a mid round injection.
 * This ignores things such as "remaining threat to spend" and "minimum time in round"
 * but should obey rules such as "minimum player count" and "requires a security officer".
 */

/datum/grand_event/midround/dragon
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_ghosts/space_dragon()
	wizard_message = "You create a gateway to the carp migration stream!"

/datum/grand_event/midround/heretic
	min_escalation = 5
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_living/waking_heretic()
	once_only = FALSE // Might be a bad idea but let's try it
	wizard_message = "Your meddling has attracted the attention of dark powers!"

/datum/grand_event/midround/nightmare
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_ghosts/nightmare()
	wizard_message = "Your meddling has attracted the attention of dark powers!"

/datum/grand_event/midround/revenant
	min_escalation = 4
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_ghosts/revenant()
	wizard_message = "Your meddling has attracted the attention of dark powers!"

/datum/grand_event/midround/wizard
	min_escalation = 7
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_ghosts/wizard()
	wizard_message = "Your meddling has attracted the attention of one of your peers!"

// Tee hee
/datum/grand_event/midround/wizard_recursion
	min_escalation = 5
	dynamic_ruleset = new /datum/dynamic_ruleset/midround/from_ghosts/wizard_journeyman()
	wizard_message = "Your meddling has attracted the attention of one of your peers!"
