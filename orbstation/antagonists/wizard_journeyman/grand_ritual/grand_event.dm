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
	/// Typecache of one-time-only events which have run already.
	var/static/list/has_run = list()
	/// Feedback message shown to the wizard, as some events are silent and they should know what they did.
	var/wizard_message

#undef NEVER

/// Returns true if an event can be fired right now.
/datum/grand_event/proc/is_valid_event(escalation)
	if (has_run[src.type])
		return FALSE
	return escalation >= min_escalation && escalation <= max_escalation

/// Makes the event happen.
/datum/grand_event/proc/trigger_event(mob/invoker)
	if (once_only)
		has_run[src.type] = 1
	if (wizard_message)
		to_chat(invoker, span_notice(wizard_message))

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

/datum/grand_event/event/trigger_event(mob/invoker)
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

/// A grand event which triggers a dynamic midround
/datum/grand_event/midround
	min_escalation = 6
	max_escalation = 7
	once_only = TRUE
	/// Dynamic ruleset to trigger
	var/datum/dynamic_ruleset/midround/dynamic_ruleset

/// Do not trigger if shuttle is coming, if the ruleset is disabled, or if there are no candidates.
/datum/grand_event/midround/is_valid_event(escalation)
	. = ..()
	if (!.)
		return
	if (!dynamic_ruleset)
		return FALSE
	if (!EMERGENCY_IDLE_OR_RECALLED)
		return FALSE
	if (dynamic_ruleset.weight == 0)
		return FALSE
	if (istype(dynamic_ruleset, /datum/dynamic_ruleset/midround/from_ghosts) && !(GLOB.ghost_role_flags & GHOSTROLE_MIDROUND_EVENT))
		return FALSE
	dynamic_ruleset.trim_candidates()
	if (!dynamic_ruleset.ready())
		return FALSE

/datum/grand_event/midround/trigger_event(mob/invoker)
	. = ..()
	var/datum/game_mode/dynamic/mode = SSticker.mode
	mode.picking_specific_rule(dynamic_ruleset, forced = TRUE, ignore_cost = TRUE)
