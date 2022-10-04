#define NEVER -1

/**
 * Describes something which can happen when the grand ritual is completed, usually not confined to the ritual location.
 * Mostly this will be triggering events of escalating danger based on how many times the ritual has already been completed.
 */
/datum/grand_event
	/// Minimum number of rituals which must be completed before this event can occur, inclusive.
	var/min_escalation = NEVER
	/// Maximum number of rituals which must be completed before this event can occur, inclusive.
	var/max_escalation = NEVER
	/// If true, never trigger this more than once
	var/once_only = FALSE

/// Returns true if an event can be fired right now.
/datum/grand_event/proc/is_valid_event(escalation)
	return escalation >= min_escalation && escalation =< max_escalation

/// Makes the event happen.
/datum/grand_event/proc/trigger_event()
	if (once_only)
		min_escalation = NEVER
		max_escalation = NEVER

/**
 * A grand event which just triggers a normal event. Pretty simple.
 */
/datum/grand_event/event
	/// Typepath of round_event_control datum for event to run.
	var/event_control_path

/// Don't trigger if we can't find the event
/datum/grand_event/event/is_valid_event(escalation)
	. = ..()
	if (!.)
		return
	if (!event_control_path)
		return FALSE
	var/datum/round_event_control/event = locate(event_control_path) in SSevents.control
	if (!event)
		return FALSE
	return TRUE

/datum/grand_event/event/trigger_event()
	. = ..()
	var/datum/round_event_control/event = locate(event_control_path) in SSevents.control
	if (!event)
		return
	event.runEvent()

/**
 * An event which requires some number of ghosts in order to run.
 */
/datum/grand_event/event/ghost
	/// Minimum number of ghosts to require. May not all actually want to participate.
	var/min_candidates = 2 // Just in case one of them has the pref disabled.

/// Returns false if we don't have a minimum number of ghosts.
/datum/grand_event/event/ghost/is_valid_event(escalation)
	. = ..()
	if (!.)
		return
	var/num_ghosts = length(GLOB.current_observers_list) + length(GLOB.dead_player_list)
	return num_ghosts >= min_candidates
