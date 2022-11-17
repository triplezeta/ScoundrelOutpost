// Confine to a specific list of traumas
/datum/round_event_control/brain_trauma
	name = "Mysterious Brain Trauma"
	description = "A crewmember experiences a terrible or occasionally helpful malady."

/datum/round_event/brain_trauma/traumatize(mob/living/carbon/human/victim)
	var/resistance = pick(
		50;TRAUMA_RESILIENCE_BASIC,
		30;TRAUMA_RESILIENCE_SURGERY,
		20;TRAUMA_RESILIENCE_LOBOTOMY)

	var/trauma_list = list(
		/datum/brain_trauma/magic/poltergeist,
		/datum/brain_trauma/magic/antimagic,
		/datum/brain_trauma/magic/stalker,
		/datum/brain_trauma/mild/hallucinations,
		/datum/brain_trauma/mild/healthy,
		/datum/brain_trauma/special/godwoken,
		/datum/brain_trauma/special/bluespace_prophet,
		/datum/brain_trauma/special/quantum_alignment,
		/datum/brain_trauma/special/death_whispers,
		/datum/brain_trauma/special/existential_crisis,
		/datum/brain_trauma/special/tenacity,
		/datum/brain_trauma/special/beepsky,
		/datum/brain_trauma/severe/hypnotic_trigger,)

	if (ghosts_exist())
		trauma_list += /datum/brain_trauma/special/imaginary_friend

	var/trauma_type = pick(trauma_list)

	if (trauma_type != /datum/brain_trauma/severe/hypnotic_trigger)
		victim.gain_trauma(new trauma_type(), resistance)
		return

	var/static/list/trigger_phrases = list("Nanotrasen", "Syndicate", "Changeling", "Ian", "Poly", "Wizard", "Shuttle", "Bomb", "Help")
	victim.gain_trauma(new /datum/brain_trauma/severe/hypnotic_trigger(pick(trigger_phrases)), resistance)

/datum/round_event/brain_trauma/proc/ghosts_exist()
	for(var/mob/dead/observer/ghost_player in GLOB.player_list)
		return TRUE
	return FALSE

/datum/round_event/anomaly/brain_trauma/announce(fake)
	if (prob(10))
		priority_announce("Negotiation over cessation of hostilities with the Wizard Federation have broken down. \
			Our negotiators believe it is possible that one of your staff may have been 'cursed' as retaliation.", "Political Update")
		return
	priority_announce("Unusual spikes of psychoactive cosmic radiation have been detected near the station. \
		Please report any unusual perceptive effects to your resident psychologist.", "Meteorological Update")
