/// Number of times you need to cast on the rune to complete it
#define GRAND_RUNE_INVOKES_TO_COMPLETE 3
/// Returns true if you're a wizard or a journeyman
/// You will probably never have both of these at the same time but if a big wizard wants to finish the rune of a small one who am I to say they can't?
#define IS_WIZARD_OR_JOURNEYMAN(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/wizard_journeyman || mob?.mind?.has_antag_datum(/datum/antagonist/wizard)))
/// Base time to take to invoke one stage of the rune. This is done three times to complete the rune.
#define BASE_INVOKE_TIME 7 SECONDS
/// Time to add on to each step every time a previous rune is completed.
#define ADD_INVOKE_TIME 1 SECONDS

/**
 * Magic rune used in the grand ritual.
 * A wizard sits themselves on this thing and waves their hands for a while shouting silly words.
 * Then something (usually bad) happens.
 */
/obj/effect/grand_rune
	name = "transmutation rune"
	desc = "A flowing circle of shapes and runes is etched into the floor, the lines twist and move before your eyes."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "eldritch_rune1"
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	/// How many prior grand rituals have been completed?
	var/potency = 0
	/// Time to take per invocation of rune.
	var/invoke_time = BASE_INVOKE_TIME
	/// Prevent ritual spam click.
	var/is_in_use = FALSE
	/// Number of times this rune has been cast
	var/times_invoked = 0
	/// Magic words you say to invoke the ritual
	var/list/magic_words = list()
	/**
	 * Possible things you can yell when invoking the rune. Wizards are silly, so... so are these.
	 * It was actually really hard to think of any three-part incantations which weren't dumb jokes.
	 * Please do contribute more if you think of some.
	 */
	var/static/list/possible_magic_words = list(
		list("Abra...", "Cadabra...", "Alakazam!"),
		list("Bibbity!", "Bobbity!", "Boo!"),
		list("Micrato", "Raepij", "Sathonich!"),
		list("Sim!", "Sala!", "Bim!"),
		list("Hocus Pocus!", "Flim Flam!", "Wabbajack!"),
		list("Esaelp!", "Ouy Knaht!", "Em Esucxe!!"),
		list("Quas!", "Wex!", "Exort!"),
		list("Ten!", "Chi!", "Jin!"),
		list("Fus", "Roh", "Dah!!"),
		list("Y-abbaa", "Dab'Bah", "Doom!!"),
		list("Azarath!", "Metrion!", "Zinthos!!"),
		list("Klaatu!", "Barada!", "Nikto!!"),
		list("Drivaron Ple'ez!", "Shabadoobie!", "Henshin!!"),
		list("Bish", "Bash", "Bosh!"),
		list("Halev Li'af!", "Epizadh!", "Free!!"),
		list("*scream", "*scream", "*scream"),
		list("One and a...", "Two and a...", "One Two Three Four!!"),
		list("Let expanse contract!", "Let eon become instant!", "Throw wide the gates!!"),
		list("The arcane is mine to command!", "Yawn wide, ever-hungering void!", "Behold, a sorcerer of eld!!"),
		list("git checkout origin master", "git reset --hard HEAD~2", "git push origin master --force!!",)
	)

// Prepare magic words and hide from silicons
/obj/effect/grand_rune/Initialize(mapload, potency = 0)
	. = ..()
	src.potency = potency
	invoke_time = (BASE_INVOKE_TIME) + (potency * (ADD_INVOKE_TIME))
	magic_words = pick(possible_magic_words)
	var/image/silicon_image = image(icon = 'icons/effects/eldritch.dmi', icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "heretic_rune", silicon_image)

#undef BASE_INVOKE_TIME
#undef ADD_INVOKE_TIME

/obj/effect/grand_rune/examine(mob/user)
	. = ..()
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		. += span_notice("It's power seems to have been expended.")
		return
	if(!IS_WIZARD_OR_JOURNEYMAN(user))
		return
	. += span_notice("Invoke this rune [GRAND_RUNE_INVOKES_TO_COMPLETE - times_invoked] more times to complete the ritual.")

/obj/effect/grand_rune/can_interact(mob/living/user)
	. = ..()
	if(!.)
		return
	if(!IS_WIZARD_OR_JOURNEYMAN(user))
		return FALSE
	if(is_in_use)
		return FALSE
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		return FALSE
	return TRUE

/obj/effect/grand_rune/interact(mob/living/user)
	. = ..()
	INVOKE_ASYNC(src, .proc/invoke_rune, user)
	return TRUE

/// Actually does the whole invoking thing
/obj/effect/grand_rune/proc/invoke_rune(mob/living/user)
	is_in_use = TRUE
	user.balloon_alert(user, "invoking rune...")
	if(!do_after(user, invoke_time, src))
		user.balloon_alert(user, "interrupted!")
		is_in_use = FALSE
		return

	times_invoked++
	user.say(magic_words[times_invoked], forced = "grand ritual invocation")

	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		is_in_use = FALSE
		SEND_SIGNAL(src, COMSIG_GRAND_RUNE_COMPLETE)
		return
	INVOKE_ASYNC(src, .proc/invoke_rune, user)

/obj/effect/grand_rune/proc/get_invoke_time()
	return  (BASE_INVOKE_TIME) + (times_completed * (ADD_INVOKE_TIME))

#undef GRAND_RUNE_INVOKES_TO_COMPLETE
#undef IS_WIZARD_OR_JOURNEYMAN
